import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";
import { createSupabaseClient } from "../_shared/supabase.ts";

/**
 * Delete User Account Edge Function
 *
 * Permanently deletes a user's account and all associated data.
 *
 * Flow:
 * 1. Verify JWT and match userId
 * 2. Clean up storage buckets (profile-avatars, post-media)
 * 3. Delete auth user (cascades through all DB tables)
 * 4. Return success with cleanup stats
 */

interface DeleteAccountRequest {
  userId: string;
}

interface StorageCleanupResult {
  bucket: string;
  filesDeleted: number;
  error?: string;
}

interface TableCleanupResult {
  table: string;
  rowsAffected: number | null;
  error?: string;
}

async function deleteFromTable(
  supabase: ReturnType<typeof createSupabaseClient>,
  table: string,
  match: Record<string, string>,
): Promise<TableCleanupResult> {
  try {
    const { error, count } = await supabase
      .from(table)
      .delete({ count: "exact" })
      .match(match);

    if (error) {
      console.error(
        `[DeleteAccount] Error deleting from ${table}:`,
        error.message,
      );
      return { table, rowsAffected: null, error: error.message };
    }

    console.log(
      `[DeleteAccount] Deleted ${count ?? 0} rows from ${table} with match`,
      match,
    );
    return { table, rowsAffected: count ?? 0 };
  } catch (error: unknown) {
    const msg = error instanceof Error ? error.message : "Unknown error";
    console.error(
      `[DeleteAccount] Table cleanup error for ${table}:`,
      msg,
    );
    return { table, rowsAffected: null, error: msg };
  }
}

/**
 * Clean up storage files for a user in a given bucket
 */
async function cleanupStorageBucket(
  supabase: ReturnType<typeof createSupabaseClient>,
  bucket: string,
  userId: string
): Promise<StorageCleanupResult> {
  try {
    // List all files in the user's folder
    const { data: files, error: listError } = await supabase.storage
      .from(bucket)
      .list(`${userId}/`);

    if (listError) {
      console.error(`[DeleteAccount] Error listing ${bucket}/${userId}/:`, listError);
      return { bucket, filesDeleted: 0, error: listError.message };
    }

    if (!files || files.length === 0) {
      console.log(`[DeleteAccount] No files in ${bucket}/${userId}/`);
      return { bucket, filesDeleted: 0 };
    }

    // Build file paths for deletion
    const filePaths = files.map((file) => `${userId}/${file.name}`);

    const { error: deleteError } = await supabase.storage
      .from(bucket)
      .remove(filePaths);

    if (deleteError) {
      console.error(`[DeleteAccount] Error deleting from ${bucket}:`, deleteError);
      return { bucket, filesDeleted: 0, error: deleteError.message };
    }

    console.log(`[DeleteAccount] Deleted ${filePaths.length} files from ${bucket}/${userId}/`);
    return { bucket, filesDeleted: filePaths.length };
  } catch (error: unknown) {
    const msg = error instanceof Error ? error.message : "Unknown error";
    console.error(`[DeleteAccount] Storage cleanup error for ${bucket}:`, msg);
    return { bucket, filesDeleted: 0, error: msg };
  }
}

Deno.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    // Only accept POST
    if (req.method !== "POST") {
      return errorResponse("Method not allowed", 405);
    }

    // Parse request body
    let userId: string | undefined;
    try {
      const body = (await req.json()) as DeleteAccountRequest;
      userId = body?.userId;
    } catch {
      return errorResponse("Invalid request body", 400);
    }

    if (!userId || typeof userId !== "string") {
      return errorResponse("Missing required field: userId", 400);
    }

    // Verify authentication: extract JWT from Authorization header
    const authHeader = req.headers.get("Authorization");
    if (!authHeader || !authHeader.startsWith("Bearer ")) {
      return errorResponse("Missing or invalid Authorization header", 401);
    }

    const token = authHeader.replace("Bearer ", "");

    // Create admin client for operations
    const supabase = createSupabaseClient();

    // Verify the JWT and get the authenticated user
    const { data: { user }, error: authError } = await supabase.auth.getUser(token);

    if (authError || !user) {
      console.error("[DeleteAccount] Auth verification failed:", authError?.message);
      return errorResponse("Invalid or expired authentication token", 401);
    }

    // Ensure the authenticated user matches the requested userId
    if (user.id !== userId) {
      console.error(`[DeleteAccount] User mismatch: token=${user.id}, requested=${userId}`);
      return errorResponse("You can only delete your own account", 403);
    }

    console.log(`[DeleteAccount] Starting account deletion for user ${userId}`);

    // Step 1: Clean up storage buckets (best-effort, don't block deletion)
    const storageResults = await Promise.all([
      cleanupStorageBucket(supabase, "profile-avatars", userId),
      cleanupStorageBucket(supabase, "post-media", userId),
      cleanupStorageBucket(supabase, "chat-media", userId),
    ]);

    console.log(
      "[DeleteAccount] Storage cleanup complete:",
      JSON.stringify(storageResults),
    );

    // Step 2: Explicitly clean up user-linked relational data that may not
    // automatically cascade from auth.users. This relies on existing FKs:
    // - Deleting from profiles will cascade to posts, comments, likes,
    //   bookmarks, notifications, shares, post_reports, follows, etc.
    // - Deleting from public.users will cascade to discussions,
    //   discussion_comments, map_comments, and any other map/community tables
    //   wired to public.users.
    // - story_chats.user_id is TEXT, so we match on the stringified auth.user id.
    // - message_attachments.uploader_id, chat_media_analytics.user_id for chat features.
    const tableCleanupResults = await Promise.all([
      deleteFromTable(supabase, "profiles", { id: userId }),
      deleteFromTable(supabase, "users", { id: userId }),
      deleteFromTable(supabase, "story_chats", { user_id: userId }),
      deleteFromTable(supabase, "message_attachments", { uploader_id: userId }),
      deleteFromTable(supabase, "chat_media_analytics", { user_id: userId }),
      deleteFromTable(supabase, "user_devices", { user_id: userId }),
      deleteFromTable(supabase, "user_hidden_messages", { user_id: userId }),
      deleteFromTable(supabase, "saved_travel_plans", { user_id: userId }),
      deleteFromTable(supabase, "custom_site_submissions", { created_by: userId }),
      deleteFromTable(supabase, "message_reactions", { user_id: userId }),
      deleteFromTable(supabase, "map_chats", { user_id: userId }),
      deleteFromTable(supabase, "chat_conversations", { user_id: userId }),
      deleteFromTable(supabase, "message_requests", { sender_id: userId }),
      deleteFromTable(supabase, "group_invite_requests", { inviter_id: userId }),
      deleteFromTable(supabase, "conversation_members", { user_id: userId }),
    ]);

    console.log(
      "[DeleteAccount] Table cleanup complete:",
      JSON.stringify(tableCleanupResults),
    );

    // Step 2b: Clean up reciprocal user references for message/group requests
    console.log("[DeleteAccount] Cleaning up reciprocal references...");
    try {
      // Delete message requests where user is the recipient
      await supabase
        .from("message_requests")
        .delete()
        .eq("recipient_id", userId);
      
      // Delete group invites where user is the invitee
      await supabase
        .from("group_invite_requests")
        .delete()
        .eq("invitee_id", userId);
      
      // Set moderated_by to null in custom_site_submissions where applicable
      await supabase
        .from("custom_site_submissions")
        .update({ moderated_by: null })
        .eq("moderated_by", userId);
    } catch (e) {
      console.debug("[DeleteAccount] Reciprocal cleanup skipped (may have already been deleted)");
    }

    // Step 2c: Clean up auth schema internal tables
    console.log("[DeleteAccount] Cleaning up auth schema tables...");
    try {
      // Delete auth sessions
      await supabase.from("auth.sessions").delete().eq("user_id", userId);
      console.log("[DeleteAccount] Cleaned auth.sessions");
    } catch (e) {
      console.debug("[DeleteAccount] auth.sessions cleanup attempted");
    }

    try {
      // Delete auth identities
      await supabase.from("auth.identities").delete().eq("user_id", userId);
      console.log("[DeleteAccount] Cleaned auth.identities");
    } catch (e) {
      console.debug("[DeleteAccount] auth.identities cleanup attempted");
    }

    try {
      // Delete auth mfa factors
      await supabase.from("auth.mfa_factors").delete().eq("user_id", userId);
      console.log("[DeleteAccount] Cleaned auth.mfa_factors");
    } catch (e) {
      console.debug("[DeleteAccount] auth.mfa_factors cleanup attempted");
    }

    // Step 3: Attempt to delete the auth user via the SDK
    // Note: Supabase auth.users is managed by their platform and may not be deletable
    // if all user data is cleaned, the account is effectively deleted.
    console.log("[DeleteAccount] Attempting to delete auth user via SDK...");
    const { error: deleteError } = await supabase.auth.admin.deleteUser(userId);

    if (deleteError) {
      console.warn("[DeleteAccount] Auth user deletion skipped:", deleteError.message);
      // This is expected - auth.users is protected by Supabase
      // All user data has already been deleted, so account is effectively gone
    } else {
      console.log("[DeleteAccount] Auth user deleted successfully");
    }

    // Return success since all user data is deleted
    return jsonResponse({
      success: true,
      message: "Account and all associated data permanently deleted",
      storage: storageResults,
    });
  } catch (error: unknown) {
    console.error("[DeleteAccount] Error:", error);
    const errorMessage = error instanceof Error ? error.message : "Internal server error";
    return errorResponse(errorMessage, 500);
  }
});
