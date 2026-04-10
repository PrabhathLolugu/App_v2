import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { generateText } from "../_shared/openrouter.ts";
import { createSupabaseClient } from "../_shared/supabase.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";
import { retryWithBackoff } from "../_shared/retry.ts";

/**
 * Generate Image Edge Function
 *
 * Generates images for stories using Gemini 2.5 Flash Image model via OpenRouter
 * and uploads them to Supabase Storage
 */

const OPENROUTER_API_URL = "https://openrouter.ai/api/v1/chat/completions";
const IMAGE_MODEL = "deepseek/deepseek-v3.2";

interface ImageRequest {
  story_id?: string;
  title?: string;
  story_content?: string;
}

// OpenRouter can return various content formats
interface ContentPart {
  type?: string;
  text?: string;
  image_url?: {
    url: string;
  };
  // Gemini native format
  inlineData?: {
    mimeType: string;
    data: string;
  };
  inline_data?: {
    mime_type: string;
    data: string;
  };
}

interface OpenRouterImageResponse {
  choices: Array<{
    message: {
      content: ContentPart[] | string;
      // Gemini returns images in a separate array
      images?: Array<{
        type: string;
        image_url?: {
          url: string;
        };
      }>;
    };
  }>;
}

/**
 * Extract image data from various response formats
 */
function extractImageData(content: ContentPart[] | string): { data: string; mimeType: string } | null {
  if (typeof content === "string") {
    // Check if it's a data URL embedded in text
    const match = content.match(/data:([^;]+);base64,([A-Za-z0-9+/=]+)/);
    if (match) {
      return { mimeType: match[1], data: match[2] };
    }
    return null;
  }

  if (!Array.isArray(content)) {
    return null;
  }

  for (const part of content) {
    // Format 1: image_url with data URL
    if (part.type === "image_url" && part.image_url?.url) {
      const match = part.image_url.url.match(/^data:([^;]+);base64,(.+)$/);
      if (match) {
        return { mimeType: match[1], data: match[2] };
      }
    }

    // Format 2: inlineData (camelCase - Gemini native)
    if (part.inlineData?.data) {
      return {
        mimeType: part.inlineData.mimeType || "image/png",
        data: part.inlineData.data,
      };
    }

    // Format 3: inline_data (snake_case)
    if (part.inline_data?.data) {
      return {
        mimeType: part.inline_data.mime_type || "image/png",
        data: part.inline_data.data,
      };
    }

    // Format 4: type is "image" with data
    if (part.type === "image" && (part as any).data) {
      return {
        mimeType: (part as any).mimeType || (part as any).mime_type || "image/png",
        data: (part as any).data,
      };
    }

    // Format 5: Direct base64 in a part without type
    if (typeof (part as any).data === "string" && !part.type) {
      const data = (part as any).data;
      // Check if it looks like base64
      if (/^[A-Za-z0-9+/=]+$/.test(data) && data.length > 100) {
        return {
          mimeType: (part as any).mimeType || (part as any).mime_type || "image/png",
          data: data,
        };
      }
    }
  }

  return null;
}

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    const supabase = createSupabaseClient();

    const body: ImageRequest = await req.json();
    let { story_id, title, story_content } = body;

    // If story_id provided, fetch the story from either table
    if (story_id && (!title || !story_content)) {
      // Try generated_stories first
      let { data: story, error } = await supabase
        .from("generated_stories")
        .select("title, story_content")
        .eq("id", story_id)
        .single();

      // Fallback to stories table if not found
      if (error || !story) {
        const storiesResult = await supabase
          .from("stories")
          .select("title, content")
          .eq("id", story_id)
          .single();

        if (storiesResult.error || !storiesResult.data) {
          return errorResponse("Story not found", 404);
        }

        // Map 'content' to 'story_content' for consistency
        story = {
          title: storiesResult.data.title,
          story_content: storiesResult.data.content,
        };
      }

      title = title || story.title;
      story_content = story_content || story.story_content;
    }

    if (!title || !story_content) {
      return errorResponse("title and story_content are required", 400);
    }

    // Step 1: Generate visual description prompt using OpenRouter text model
    const storySummary = story_content.substring(0, 2000) +
      (story_content.length > 2000 ? "..." : "");

    const promptGenerationRequest = `You are an expert at creating detailed, vivid image generation prompts for scriptural and epic stories from Indian scriptures.

Based on the following story, create a concise but detailed prompt (2-3 sentences) that would generate a beautiful, epic illustration capturing the essence and key visual elements of this story.

Story Title: ${title}

Story:
${storySummary}

Create an image generation prompt that:
1. Describes the main scene, characters, and setting
2. Includes artistic style (epic, scriptural, divine, ancient Indian art style, traditional Indian painting style)
3. Uses cinematic bluish golden lighting with idealized anatomy and intricate detailing
4. Captures the emotional tone and key visual elements
5. Is suitable for generating a single, impactful illustration
6. Mentions vibrant colors, detailed composition, spiritual atmosphere
7. Ensures characters match their descriptions in Indian scriptures

Respond with ONLY the image generation prompt, nothing else.`;

    const imagePrompt = await retryWithBackoff(async () => {
      return await generateText(promptGenerationRequest, undefined, {
        temperature: 0.7,
        max_tokens: 300,
      });
    });

    console.log("Generated image prompt:", imagePrompt.trim());

    // Step 2: Generate image using Gemini 2.5 Flash Image via OpenRouter
    const rawKey = Deno.env.get("OPENROUTER_API_KEY") ?? "";
    let openrouterApiKey = rawKey.trim();
    if (openrouterApiKey.includes("=")) {
      openrouterApiKey = openrouterApiKey.split("=").pop()?.trim() ?? openrouterApiKey;
    }
    openrouterApiKey = openrouterApiKey.replace(/^["']|["']$/g, "");
    if (!openrouterApiKey) {
      throw new Error("OPENROUTER_API_KEY not configured");
    }

    const imageResponse = await retryWithBackoff(async () => {
      const response = await fetch(OPENROUTER_API_URL, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${openrouterApiKey}`,
          "Content-Type": "application/json",
          "HTTP-Referer": "https://myitihas.app",
          "X-Title": "MyItihas",
        },
        body: JSON.stringify({
          model: IMAGE_MODEL,
          messages: [
            {
              role: "user",
              content: `Generate an image: ${imagePrompt.trim()}`,
            },
          ],
          max_tokens: 4096,
        }),
      });

      if (!response.ok) {
        const errorBody = await response.text();
        throw new Error(`Image generation error: ${response.status} - ${errorBody}`);
      }

      return await response.json();
    });

    // Log full response structure for debugging
    console.log("Full API response:", JSON.stringify(imageResponse, null, 2));

    // Extract image data from response
    // Gemini returns images in message.images array
    const message = imageResponse.choices?.[0]?.message;
    const content = message?.content;
    const images = message?.images;

    let extracted = extractImageData(content);

    // If not found in content, check the images array
    if (!extracted && images && Array.isArray(images)) {
      for (const img of images) {
        if (img.type === "image_url" && img.image_url?.url) {
          const match = img.image_url.url.match(/^data:([^;]+);base64,(.+)$/);
          if (match) {
            extracted = { mimeType: match[1], data: match[2] };
            break;
          }
        }
      }
    }

    if (!extracted) {
      console.error("Failed to extract image. Content:", JSON.stringify(content, null, 2));
      console.error("Images array:", JSON.stringify(images, null, 2));
      throw new Error("No image data received from Gemini. The model may have returned text instead of an image.");
    }

    const { data: imageData, mimeType } = extracted;
    console.log("Extracted image with mimeType:", mimeType, "data length:", imageData.length);

    // Step 3: Upload to Supabase Storage
    const extension = mimeType.includes("jpeg") || mimeType.includes("jpg") ? "jpg" : "png";
    const fileName = `${story_id || crypto.randomUUID()}-${Date.now()}.${extension}`;

    // Convert base64 to Uint8Array
    const binaryString = atob(imageData);
    const bytes = new Uint8Array(binaryString.length);
    for (let i = 0; i < binaryString.length; i++) {
      bytes[i] = binaryString.charCodeAt(i);
    }

    const { error: uploadError } = await supabase.storage
      .from("story-images")
      .upload(fileName, bytes, {
        contentType: mimeType,
        cacheControl: "3600",
        upsert: false,
      });

    if (uploadError) {
      console.error("Storage upload error:", uploadError);
      throw new Error(`Failed to upload image: ${uploadError.message}`);
    }

    // Step 4: Get public URL
    const { data: urlData } = supabase.storage
      .from("story-images")
      .getPublicUrl(fileName);

    const publicUrl = urlData.publicUrl;

    // Step 5: Update story with image URL in both tables if story_id provided
    if (story_id) {
      // Update generated_stories table
      const { error: genUpdateError } = await supabase
        .from("generated_stories")
        .update({ image_url: publicUrl })
        .eq("id", story_id);

      // Update stories table (may not exist there, that's ok)
      const { error: storiesUpdateError } = await supabase
        .from("stories")
        .update({ image_url: publicUrl })
        .eq("id", story_id);

      if (genUpdateError && storiesUpdateError) {
        console.error("Failed to update story with image URL in both tables:", {
          generated_stories: genUpdateError,
          stories: storiesUpdateError,
        });
        // Don't fail the request, image was uploaded successfully
      }
    }

    return jsonResponse({
      image_url: publicUrl,
      prompt: imagePrompt.trim(),
    });

  } catch (error) {
    console.error("Error in generate-image:", error);
    const message = error instanceof Error ? error.message : "Unknown error";

    if (message.includes("429") || message.toLowerCase().includes("rate")) {
      return errorResponse(
        "Image generation servers are busy. Please try again in a moment.",
        503
      );
    }

    return errorResponse(`Failed to generate image: ${message}`, 500);
  }
});
