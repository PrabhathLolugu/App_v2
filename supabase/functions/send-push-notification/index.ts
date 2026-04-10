import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";
import { createSupabaseClient } from "../_shared/supabase.ts";

/**
 * Send Push Notification Edge Function
 *
 * Sends FCM push notifications to user devices when triggered by the
 * database notification insert trigger.
 *
 * Flow:
 * 1. Receive notification data from trigger
 * 2. Look up user's active FCM tokens from user_devices table
 * 3. Send FCM message to each device
 * 4. Update notification record with delivery status
 * 5. Handle invalid tokens by marking devices inactive
 */

// Types
interface NotificationPayload {
  notification_id: string;
  user_id: string;
  title: string;
  body: string;
  notification_type?: string;
  entity_type?: string;
  entity_id?: string;
  action_url?: string;
  actor_id?: string;
  metadata?: Record<string, unknown>;
}

interface FCMMessage {
  message: {
    token: string;
    notification: {
      title: string;
      body: string;
    };
    data: Record<string, string>;
    android?: {
      priority: string;
      ttl?: string;
      direct_boot_ok?: boolean;
      notification?: {
        channel_id: string;
        icon?: string;
        color?: string;
      };
    };
    apns?: {
      headers?: Record<string, string>;
      payload: {
        aps: {
          alert: {
            title: string;
            body: string;
          };
          sound: string;
          badge?: number;
          "content-available"?: number;
        };
      };
    };
    webpush?: {
      notification: {
        title: string;
        body: string;
        icon?: string;
      };
    };
  };
}

interface FCMResponse {
  name?: string;
  error?: {
    code: number;
    message: string;
    status: string;
    details?: Array<{
      "@type": string;
      errorCode?: string;
    }>;
  };
}

interface ServiceAccount {
  type: string;
  project_id: string;
  private_key_id: string;
  private_key: string;
  client_email: string;
  client_id: string;
  auth_uri: string;
  token_uri: string;
  auth_provider_x509_cert_url: string;
  client_x509_cert_url: string;
}

interface UserDeviceRow {
  id: string;
  fcm_token: string;
  device_type: string | null;
}

interface SendResult {
  device_id: string;
  success: boolean;
  reason?: string;
  message_id?: string;
}

type DenoRuntime = {
  serve: (handler: (req: Request) => Response | Promise<Response>) => void;
  env: {
    get: (key: string) => string | undefined;
  };
};

const denoRuntime = (globalThis as typeof globalThis & { Deno: DenoRuntime })
  .Deno;

// JWT creation for Google OAuth2
async function createSignedJWT(serviceAccount: ServiceAccount): Promise<string> {
  const header = {
    alg: "RS256",
    typ: "JWT",
  };

  const now = Math.floor(Date.now() / 1000);
  const payload = {
    iss: serviceAccount.client_email,
    sub: serviceAccount.client_email,
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600, // 1 hour
    scope: "https://www.googleapis.com/auth/firebase.messaging",
  };

  const encoder = new TextEncoder();

  // Base64url encode header and payload
  const headerB64 = base64urlEncode(JSON.stringify(header));
  const payloadB64 = base64urlEncode(JSON.stringify(payload));
  const unsignedToken = `${headerB64}.${payloadB64}`;

  // Import private key
  const privateKey = await importPrivateKey(serviceAccount.private_key);

  // Sign the token
  const signature = await crypto.subtle.sign(
    { name: "RSASSA-PKCS1-v1_5" },
    privateKey,
    encoder.encode(unsignedToken)
  );

  const signatureB64 = base64urlEncode(
    String.fromCharCode(...new Uint8Array(signature))
  );

  return `${unsignedToken}.${signatureB64}`;
}

function base64urlEncode(str: string): string {
  const base64 = btoa(str);
  return base64.replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

async function importPrivateKey(pem: string): Promise<CryptoKey> {
  // Remove PEM headers and decode
  const pemContents = pem
    .replace(/-----BEGIN PRIVATE KEY-----/g, "")
    .replace(/-----END PRIVATE KEY-----/g, "")
    .replace(/\n/g, "");

  const binaryDer = Uint8Array.from(atob(pemContents), (c) => c.charCodeAt(0));

  return await crypto.subtle.importKey(
    "pkcs8",
    binaryDer,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"]
  );
}

// Cache for access token
let accessTokenCache: { token: string; expiresAt: number } | null = null;

async function getAccessToken(serviceAccount: ServiceAccount): Promise<string> {
  // Check cache
  if (accessTokenCache && Date.now() < accessTokenCache.expiresAt - 60000) {
    return accessTokenCache.token;
  }

  // Create signed JWT
  const jwt = await createSignedJWT(serviceAccount);

  // Exchange JWT for access token
  const response = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: jwt,
    }),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`Failed to get access token: ${error}`);
  }

  const data = await response.json();

  // Cache the token
  accessTokenCache = {
    token: data.access_token,
    expiresAt: Date.now() + data.expires_in * 1000,
  };

  return data.access_token;
}

/**
 * Send FCM message to a single device
 */
async function sendFCMMessage(
  token: string,
  title: string,
  body: string,
  data: Record<string, string>,
  projectId: string,
  accessToken: string
): Promise<FCMResponse> {
  const fcmMessage: FCMMessage = {
    message: {
      token,
      notification: {
        title,
        body,
      },
      data,
      android: {
        priority: "high",
        ttl: "86400s",
        direct_boot_ok: true,
        notification: {
          channel_id: "myitihas_notifications",
          icon: "ic_notification",
          color: "#0088FF", // MyItihas app theme blue (purple #44009F → blue #0088FF gradient)
        },
      },
      apns: {
        headers: {
          "apns-priority": "10",
          "apns-push-type": "alert",
        },
        payload: {
          aps: {
            alert: { title, body },
            sound: "default",
            "content-available": 1,
          },
        },
      },
      webpush: {
        notification: {
          title,
          body,
          icon: "/icons/icon-192x192.png",
        },
      },
    },
  };

  const response = await fetch(
    `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${accessToken}`,
      },
      body: JSON.stringify(fcmMessage),
    }
  );

  return (await response.json()) as FCMResponse;
}

/**
 * Check if FCM error indicates invalid token
 */
function isInvalidTokenError(response: FCMResponse): boolean {
  if (!response.error) return false;

  const invalidCodes = [
    "UNREGISTERED",
    "INVALID_ARGUMENT",
    "NOT_FOUND",
  ];

  // Check error status
  if (invalidCodes.includes(response.error.status)) {
    return true;
  }

  // Check error details
  const details = response.error.details || [];
  for (const detail of details) {
    if (detail.errorCode && invalidCodes.includes(detail.errorCode)) {
      return true;
    }
  }

  return false;
}

/**
 * Main request handler
 */
denoRuntime.serve(async (req: Request) => {
  // Handle CORS preflight
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  try {
    // Parse request body
    const payload: NotificationPayload = await req.json();

    // Validate required fields
    if (!payload.notification_id || !payload.user_id) {
      return errorResponse("Missing required fields: notification_id, user_id", 400);
    }

    console.log(`[FCM] Processing notification ${payload.notification_id} for user ${payload.user_id}`);

    // Get Firebase credentials from environment
    const firebaseProjectId = denoRuntime.env.get("FIREBASE_PROJECT_ID");
    const firebaseServiceAccountJson = denoRuntime.env.get("FIREBASE_SERVICE_ACCOUNT_JSON");

    if (!firebaseProjectId || !firebaseServiceAccountJson) {
      console.error("[FCM] Missing Firebase credentials");
      return errorResponse("FCM not configured", 500);
    }

    // Parse service account
    let serviceAccount: ServiceAccount;
    try {
      serviceAccount = JSON.parse(firebaseServiceAccountJson);
    } catch {
      console.error("[FCM] Invalid service account JSON");
      return errorResponse("Invalid FCM configuration", 500);
    }

    // Create Supabase client
    const supabase = createSupabaseClient();

    // Get active devices for user
    const { data: devices, error: devicesError } = await supabase
      .from("user_devices")
      .select("id, fcm_token, device_type")
      .eq("user_id", payload.user_id)
      .eq("is_active", true);

    if (devicesError) {
      console.error("[FCM] Error fetching devices:", devicesError);
      return errorResponse("Failed to fetch user devices", 500);
    }

    if (!devices || devices.length === 0) {
      console.log("[FCM] No active devices found for user");
      return jsonResponse({ success: true, sent: 0, message: "No active devices" });
    }

    console.log(`[FCM] Found ${devices.length} active device(s)`);

    // Get access token
    const accessToken = await getAccessToken(serviceAccount);

    const metadata =
      payload.metadata && typeof payload.metadata === "object"
        ? payload.metadata
        : {};

    const metadataString = (key: string): string => {
      const value = metadata[key];
      if (value === null || value === undefined) return "";
      return String(value);
    };

    const conversationId =
      metadataString("conversation_id") ||
      (payload.entity_type === "conversation" ? payload.entity_id || "" : "");

    // Prepare notification data
    const notificationData: Record<string, string> = {
      notification_id: payload.notification_id,
      notification_type: payload.notification_type || "",
      entity_type: payload.entity_type || "",
      entity_id: payload.entity_id || "",
      action_url: payload.action_url || "",
      actor_id: payload.actor_id || "",
      conversation_id: conversationId,
      sender_id: metadataString("sender_id") || payload.actor_id || "",
      sender_name: metadataString("sender_name"),
      sender_avatar_url: metadataString("sender_avatar_url"),
      avatar_url: metadataString("sender_avatar_url"),
      is_group: metadataString("is_group"),
      content_type: metadataString("content_type"),
      target_comment_id: metadataString("target_comment_id"),
      parent_entity_type: metadataString("parent_entity_type"),
      parent_entity_id: metadataString("parent_entity_id"),
    };

    // Send to all devices
    const deviceRows = devices as UserDeviceRow[];
    const results = await Promise.allSettled<SendResult>(
      deviceRows.map(async (device: UserDeviceRow): Promise<SendResult> => {
        const response = await sendFCMMessage(
          device.fcm_token,
          payload.title,
          payload.body,
          notificationData,
          firebaseProjectId,
          accessToken
        );

        // Handle invalid tokens
        if (isInvalidTokenError(response)) {
          console.log(`[FCM] Marking device ${device.id} as inactive (invalid token)`);
          await supabase
            .from("user_devices")
            .update({ is_active: false, updated_at: new Date().toISOString() })
            .eq("id", device.id);
          return { device_id: device.id, success: false, reason: "invalid_token" };
        }

        if (response.error) {
          console.error(`[FCM] Error sending to device ${device.id}:`, response.error);
          return { device_id: device.id, success: false, reason: response.error.message };
        }

        console.log(`[FCM] Successfully sent to device ${device.id}`);
        return {
          device_id: device.id,
          success: true,
          message_id: response.name,
        };
      })
    );

    // Count successful sends
    const successCount = results.filter((r: PromiseSettledResult<SendResult>) => {
      return r.status === "fulfilled" && r.value.success;
    }).length;

    // Get first successful message ID
    const firstSuccessResult = results.find((r: PromiseSettledResult<SendResult>) => {
      return r.status === "fulfilled" && r.value.success && !!r.value.message_id;
    });
    const messageId =
      firstSuccessResult?.status === "fulfilled"
        ? firstSuccessResult.value.message_id
        : null;

    // Update notification record with FCM status
    const { error: updateError } = await supabase
      .from("notifications")
      .update({
        fcm_sent: successCount > 0,
        fcm_sent_at: successCount > 0 ? new Date().toISOString() : null,
        fcm_message_id: messageId,
      })
      .eq("id", payload.notification_id);

    if (updateError) {
      console.error("[FCM] Error updating notification:", updateError);
    }

    console.log(`[FCM] Completed: ${successCount}/${devices.length} devices`);

    return jsonResponse({
      success: true,
      sent: successCount,
      total: devices.length,
      message_id: messageId,
    });
  } catch (error: unknown) {
    console.error("[FCM] Error:", error);
    const errorMessage = error instanceof Error ? error.message : "Internal server error";
    return errorResponse(errorMessage, 500);
  }
});
