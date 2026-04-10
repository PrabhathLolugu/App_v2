/**
 * CORS Headers Configuration
 */

export const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, PUT, DELETE, OPTIONS",
  "Access-Control-Allow-Headers":
    "authorization, x-client-info, apikey, content-type",
};

/**
 * Handle OPTIONS preflight requests
 */
export function handleOptions(): Response {
  return new Response(null, {
    status: 204,
    headers: corsHeaders,
  });
}

/**
 * Create a JSON response with CORS headers
 */
export function jsonResponse(
  data: unknown,
  status: number = 200,
): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": "application/json",
    },
  });
}

/**
 * Create an error response with CORS headers
 */
export function errorResponse(
  message: string,
  status: number = 500,
  details?: unknown,
): Response {
  return jsonResponse(
    {
      error: message,
      ...(details && { details }),
    },
    status,
  );
}

/**
 * Create a binary response (e.g. audio) with CORS headers
 */
export function binaryResponse(
  body: ArrayBuffer | Uint8Array,
  contentType: string = "application/octet-stream",
  status: number = 200,
): Response {
  return new Response(body, {
    status,
    headers: {
      ...corsHeaders,
      "Content-Type": contentType,
    },
  });
}
