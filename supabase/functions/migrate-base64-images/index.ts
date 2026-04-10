import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createSupabaseClient } from "../_shared/supabase.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";

/**
 * Migrate Base64 Images Edge Function
 *
 * Finds rows with base64-encoded images in image_url fields,
 * uploads them to Supabase Storage, and updates the field with the storage URL.
 *
 * Affected tables:
 * - generated_stories (image_url)
 * - community_stories (image_url)
 * - stories (image_url)
 */

interface MigrationResult {
  table: string;
  id: string;
  success: boolean;
  newUrl?: string;
  error?: string;
}

interface MigrationSummary {
  totalProcessed: number;
  successful: number;
  failed: number;
  results: MigrationResult[];
}

/**
 * Extract base64 data and mime type from a data URL or detect raw base64
 */
function parseImageData(imageData: string): { mimeType: string; data: string } | null {
  // Handle data URL format: data:image/png;base64,xxxxx
  const dataUrlMatch = imageData.match(/^data:([^;]+);base64,(.+)$/);
  if (dataUrlMatch) {
    return {
      mimeType: dataUrlMatch[1],
      data: dataUrlMatch[2],
    };
  }

  // Handle raw base64 data (detect by magic bytes)
  // PNG starts with iVBORw0KGgo
  if (imageData.startsWith("iVBORw0KGgo")) {
    return {
      mimeType: "image/png",
      data: imageData,
    };
  }

  // JPEG starts with /9j/
  if (imageData.startsWith("/9j/")) {
    return {
      mimeType: "image/jpeg",
      data: imageData,
    };
  }

  // GIF starts with R0lGOD
  if (imageData.startsWith("R0lGOD")) {
    return {
      mimeType: "image/gif",
      data: imageData,
    };
  }

  // WebP starts with UklGR
  if (imageData.startsWith("UklGR")) {
    return {
      mimeType: "image/webp",
      data: imageData,
    };
  }

  return null;
}

/**
 * Get file extension from mime type
 */
function getExtension(mimeType: string): string {
  if (mimeType.includes("jpeg") || mimeType.includes("jpg")) return "jpg";
  if (mimeType.includes("gif")) return "gif";
  if (mimeType.includes("webp")) return "webp";
  return "png";
}

/**
 * Upload base64 image to Supabase Storage
 */
async function uploadImage(
  supabase: ReturnType<typeof createSupabaseClient>,
  base64Data: string,
  mimeType: string,
  fileName: string
): Promise<string> {
  // Convert base64 to Uint8Array
  const binaryString = atob(base64Data);
  const bytes = new Uint8Array(binaryString.length);
  for (let i = 0; i < binaryString.length; i++) {
    bytes[i] = binaryString.charCodeAt(i);
  }

  // Upload to storage
  const { error: uploadError } = await supabase.storage
    .from("story-images")
    .upload(fileName, bytes, {
      contentType: mimeType,
      cacheControl: "3600",
      upsert: false,
    });

  if (uploadError) {
    // If file already exists, try with a different name
    if (uploadError.message.includes("already exists")) {
      const newFileName = `${Date.now()}-${fileName}`;
      const { error: retryError } = await supabase.storage
        .from("story-images")
        .upload(newFileName, bytes, {
          contentType: mimeType,
          cacheControl: "3600",
          upsert: false,
        });

      if (retryError) {
        throw new Error(`Failed to upload image: ${retryError.message}`);
      }

      const { data: urlData } = supabase.storage
        .from("story-images")
        .getPublicUrl(newFileName);
      return urlData.publicUrl;
    }

    throw new Error(`Failed to upload image: ${uploadError.message}`);
  }

  // Get public URL
  const { data: urlData } = supabase.storage
    .from("story-images")
    .getPublicUrl(fileName);

  return urlData.publicUrl;
}

/**
 * Check if a string is a valid URL
 */
function isValidUrl(str: string): boolean {
  return str.startsWith("http://") || str.startsWith("https://");
}

/**
 * Check if a string looks like base64 image data
 */
function isBase64Image(str: string): boolean {
  if (!str || str.length < 100) return false;
  if (isValidUrl(str)) return false;

  // Check for data URL format
  if (str.startsWith("data:image")) return true;

  // Check for raw base64 magic bytes
  if (str.startsWith("iVBORw0KGgo")) return true; // PNG
  if (str.startsWith("/9j/")) return true; // JPEG
  if (str.startsWith("R0lGOD")) return true; // GIF
  if (str.startsWith("UklGR")) return true; // WebP

  return false;
}

/**
 * Process a single table and migrate base64 images
 */
async function migrateTable(
  supabase: ReturnType<typeof createSupabaseClient>,
  tableName: string,
  limit: number
): Promise<MigrationResult[]> {
  const results: MigrationResult[] = [];

  // Fetch all rows with image_url that are not null and not already URLs
  const { data: rows, error: fetchError } = await supabase
    .from(tableName)
    .select("id, image_url")
    .not("image_url", "is", null)
    .not("image_url", "like", "http%")
    .limit(limit);

  if (fetchError) {
    console.error(`Error fetching from ${tableName}:`, fetchError);
    return results;
  }

  if (!rows || rows.length === 0) {
    console.log(`No base64 images found in ${tableName}`);
    return results;
  }

  // Filter to only base64 images
  const base64Rows = rows.filter((row) => isBase64Image(row.image_url));

  if (base64Rows.length === 0) {
    console.log(`No valid base64 images found in ${tableName}`);
    return results;
  }

  console.log(`Found ${base64Rows.length} base64 images in ${tableName}`);

  for (const row of base64Rows) {
    const result: MigrationResult = {
      table: tableName,
      id: row.id,
      success: false,
    };

    try {
      // Parse the image data
      const parsed = parseImageData(row.image_url);
      if (!parsed) {
        result.error = "Invalid base64 image format";
        results.push(result);
        continue;
      }

      // Generate filename
      const extension = getExtension(parsed.mimeType);
      const fileName = `migrated-${tableName}-${row.id}-${Date.now()}.${extension}`;

      // Upload to storage
      const publicUrl = await uploadImage(supabase, parsed.data, parsed.mimeType, fileName);

      // Update the database row
      const { error: updateError } = await supabase
        .from(tableName)
        .update({ image_url: publicUrl })
        .eq("id", row.id);

      if (updateError) {
        result.error = `Failed to update row: ${updateError.message}`;
        results.push(result);
        continue;
      }

      result.success = true;
      result.newUrl = publicUrl;
      console.log(`Migrated ${tableName}/${row.id} -> ${publicUrl}`);
    } catch (error) {
      result.error = error instanceof Error ? error.message : "Unknown error";
    }

    results.push(result);
  }

  return results;
}

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    const supabase = createSupabaseClient();

    // Parse optional parameters
    let limit = 100; // Default limit per table
    let tables = ["generated_stories", "community_stories", "stories"];

    if (req.method === "POST") {
      try {
        const body = await req.json();
        if (body.limit && typeof body.limit === "number") {
          limit = Math.min(body.limit, 500); // Max 500 per request
        }
        if (body.tables && Array.isArray(body.tables)) {
          tables = body.tables;
        }
      } catch {
        // Ignore JSON parsing errors, use defaults
      }
    }

    console.log(`Starting migration for tables: ${tables.join(", ")}, limit: ${limit}`);

    const summary: MigrationSummary = {
      totalProcessed: 0,
      successful: 0,
      failed: 0,
      results: [],
    };

    // Process each table
    for (const table of tables) {
      const tableResults = await migrateTable(supabase, table, limit);
      summary.results.push(...tableResults);
    }

    // Calculate summary
    summary.totalProcessed = summary.results.length;
    summary.successful = summary.results.filter((r) => r.success).length;
    summary.failed = summary.results.filter((r) => !r.success).length;

    console.log(`Migration complete. Processed: ${summary.totalProcessed}, Success: ${summary.successful}, Failed: ${summary.failed}`);

    return jsonResponse(summary);
  } catch (error) {
    console.error("Error in migrate-base64-images:", error);
    const message = error instanceof Error ? error.message : "Unknown error";
    return errorResponse(`Migration error: ${message}`, 500);
  }
});
