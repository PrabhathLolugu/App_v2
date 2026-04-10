import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";

/**
 * Forgot Password - Check if email is registered
 *
 * Used to avoid showing "Password reset email sent" for unregistered emails.
 * Supabase's resetPasswordForEmail() returns success even for unknown emails
 * (to prevent email enumeration), so we use the Admin API here to check
 * registration before the client sends the reset email.
 *
 * POST body: { "email": "user@example.com" }
 * Returns: { "registered": true } or { "registered": false }
 */

interface ForgotPasswordRequest {
  email?: string;
}

interface AdminUser {
  email?: string;
}

interface AdminUsersListResponse {
  users?: AdminUser[];
  next_page?: number | null;
}

function isEmailRegisteredInAuthUsers(
  users: AdminUser[] | undefined,
  normalizedEmail: string,
): boolean {
  if (!Array.isArray(users)) return false;
  return users.some((user) => {
    const userEmail =
      typeof user?.email === "string" ? user.email.trim().toLowerCase() : "";
    return userEmail === normalizedEmail;
  });
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    if (req.method !== "POST") {
      return errorResponse("Method not allowed", 405);
    }

    const body = (await req.json()) as ForgotPasswordRequest;
    const email = typeof body?.email === "string" ? body.email.trim().toLowerCase() : "";

    console.log("[ForgotPassword] Request received with email:", email);
    console.log("[ForgotPassword] Request body structure:", JSON.stringify(body));

    if (!email || !email.includes("@")) {
      console.warn("[ForgotPassword] Invalid email format:", email);
      return errorResponse("Invalid email", 400);
    }

    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !serviceRoleKey) {
      console.error("[ForgotPassword] Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
      return errorResponse("Server configuration error", 500);
    }

    // Query auth users through GoTrue admin API.
    // First attempt a direct email filter (most reliable + fastest).
    const usersUrl = `${supabaseUrl}/auth/v1/admin/users`;
    const directLookupUrl = `${usersUrl}?email=${encodeURIComponent(email)}`;
    console.log("[ForgotPassword] Attempting direct email lookup...");
    
    const directRes = await fetch(directLookupUrl, {
      method: "GET",
      headers: {
        Authorization: `Bearer ${serviceRoleKey}`,
        apikey: serviceRoleKey,
        "Content-Type": "application/json",
      },
    });

    console.log("[ForgotPassword] Direct lookup response status:", directRes.status);
    
    if (directRes.ok) {
      const payload = (await directRes.json()) as AdminUsersListResponse;
      console.log("[ForgotPassword] Direct lookup payload:", JSON.stringify(payload));
      console.log("[ForgotPassword] Number of users found:", payload.users?.length ?? 0);
      
      const isRegistered = isEmailRegisteredInAuthUsers(payload.users, email);
      console.log("[ForgotPassword] Direct lookup result: registered =", isRegistered);
      
      if (isRegistered) {
        console.log("[ForgotPassword] Email IS registered. Returning { registered: true }");
        return jsonResponse({ registered: true });
      }
      
      console.log("[ForgotPassword] Email is NOT registered. Returning { registered: false }");
      return jsonResponse({ registered: false });
    }

    // Fallback pagination path if project/GoTrue version does not support
    // direct email filter. We iterate until results end.
    console.log("[ForgotPassword] Direct lookup failed with status", directRes.status, "- falling back to pagination");
    const perPage = 200;
    let page = 1;
    while (true) {
      console.log("[ForgotPassword] Pagination - fetching page", page);
      
      const listRes = await fetch(`${usersUrl}?page=${page}&per_page=${perPage}`, {
        method: "GET",
        headers: {
          Authorization: `Bearer ${serviceRoleKey}`,
          apikey: serviceRoleKey,
          "Content-Type": "application/json",
        },
      });

      if (!listRes.ok) {
        const errorBody = await listRes.text().catch(() => "");
        console.error("[ForgotPassword] Admin users API error:", listRes.status, errorBody);
        return errorResponse("Unable to verify email. Please try again.", 500);
      }

      const payload = (await listRes.json()) as AdminUsersListResponse;
      const users = payload.users ?? [];
      console.log("[ForgotPassword] Pagination page", page, '- found', users.length, 'users');

      if (isEmailRegisteredInAuthUsers(users, email)) {
        console.log("[ForgotPassword] Found matching email via pagination. Returning { registered: true }");
        return jsonResponse({ registered: true });
      }

      // End pagination when page is not full.
      if (users.length < perPage) {
        console.log("[ForgotPassword] Reached end of pagination (page had', users.length, 'users, less than per_page of', perPage, ')");
        break;
      }

      const nextPage = payload.next_page;
      if (typeof nextPage === "number" && nextPage > page) {
        page = nextPage;
      } else {
        page += 1;
      }
    }

    console.log("[ForgotPassword] Email not found in any pagination page. Returning { registered: false }");
    return jsonResponse({ registered: false });
  } catch (error: unknown) {
    console.error("[ForgotPassword] Error:", error);
    const message = error instanceof Error ? error.message : "Internal server error";
    return errorResponse(message, 500);
  }
});
