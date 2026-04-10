import { serve } from "https://deno.land/std@0.175.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.35.0";

// SSRF blocklist: internal IP ranges
const BLOCKED_HOSTS = [
  "localhost",
  "127.0.0.1",
  "0.0.0.0",
  "169.254.169.254", // AWS metadata
  /^10\./,
  /^172\.(1[6-9]|2[0-9]|3[01])\./,
  /^192\.168\./,
  /^fc[0-9a-f]{2}:/i, // IPv6 link-local
  /^fe[89a-f][0-9a-f]:/i, // IPv6 link-local
];

interface LinkPreviewMessage {
  id: string;
  url: string;
}

interface PreviewContext {
  previewId: string;
  messageId: string;
  senderId: string;
  conversationId: string;
}

async function insertAnalyticsSafe(
  supabase: ReturnType<typeof createClient>,
  payload: Record<string, unknown>
): Promise<void> {
  try {
    await supabase.from("chat_media_analytics").insert(payload);
  } catch (error) {
    console.error("Analytics insert error:", error);
  }
}

// Simple HTML parser to extract OG tags
function parseOpenGraphMeta(html: string): {
  title?: string;
  description?: string;
  imageUrl?: string;
  siteName?: string;
} {
  const result: {
    title?: string;
    description?: string;
    imageUrl?: string;
    siteName?: string;
  } = {};

  const ogRegex =
    /<meta\s+(?:property|name)=["']og:(\w+)["']\s+content=["']([^"']*)/gi;
  let match;

  while ((match = ogRegex.exec(html)) !== null) {
    const key = match[1].toLowerCase();
    const value = match[2];

    if (key === "title") result.title = value;
    if (key === "description") result.description = value;
    if (key === "image") result.imageUrl = value;
    if (key === "site_name") result.siteName = value;
  }

  // Fallback to title tag if no og:title
  if (!result.title) {
    const titleMatch = html.match(/<title[^>]*>([^<]+)<\/title>/i);
    if (titleMatch) result.title = titleMatch[1];
  }

  return result;
}

function isSafeHost(hostname: string): boolean {
  for (const blocked of BLOCKED_HOSTS) {
    if (typeof blocked === "string") {
      if (hostname === blocked) return false;
    } else if (blocked.test(hostname)) {
      return false;
    }
  }
  return true;
}

async function fetchLinkPreview(
  url: string
): Promise<{
  title?: string;
  description?: string;
  imageUrl?: string;
  siteName?: string;
}> {
  try {
    // Validate URL
    const urlObj = new URL(url);

    // SSRF protection
    if (!isSafeHost(urlObj.hostname)) {
      console.log(`Blocked unsafe host: ${urlObj.hostname}`);
      return {};
    }

    // Fetch with timeout and size limits
    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), 10000); // 10s timeout

    const response = await fetch(url, {
      method: "GET",
      headers: {
        "User-Agent":
          "Mozilla/5.0 (compatible; MyItihasBot/1.0; +http://myItihas.local)",
      },
      signal: controller.signal,
    });

    clearTimeout(timeoutId);

    if (!response.ok) {
      console.log(`Failed to fetch ${url}: ${response.status}`);
      return {};
    }

    // Check content-length to avoid huge downloads
    const contentLength = response.headers.get("content-length");
    if (contentLength && parseInt(contentLength) > 5_000_000) {
      console.log(`Content too large: ${contentLength} bytes`);
      return {};
    }

    // Read only first 500KB
    const reader = response.body?.getReader();
    if (!reader) return {};

    let html = "";
    const decoder = new TextDecoder();

    while (html.length < 500_000) {
      const { done, value } = await reader.read();
      if (done) break;
      html += decoder.decode(value, { stream: true });
    }

    const metadata = parseOpenGraphMeta(html);
    return metadata;
  } catch (error) {
    console.error(`Error fetching link preview for ${url}:`, error);
    return {};
  }
}

serve(async (req: Request) => {
  try {
    // Only accept POST requests
    if (req.method !== "POST") {
      return new Response(JSON.stringify({ error: "Method not allowed" }), {
        status: 405,
      });
    }

    const payload: { data: LinkPreviewMessage } = await req.json();
    const { id: previewId, url } = payload.data;

    if (!previewId || !url) {
      return new Response(
        JSON.stringify({ error: "Missing previewId or url" }),
        { status: 400 }
      );
    }

    // Fetch OG metadata
    const metadata = await fetchLinkPreview(url);

    // Update database
    const supabaseUrl = Deno.env.get("SUPABASE_URL");
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY");

    if (!supabaseUrl || !supabaseServiceKey) {
      throw new Error("Missing Supabase env vars");
    }

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    const { data: featureFlagRow } = await supabase
      .from("feature_flags")
      .select("enabled")
      .eq("key", "chat_link_preview_enabled")
      .maybeSingle();

    if (!(featureFlagRow?.enabled === true)) {
      return new Response(
        JSON.stringify({ success: true, skipped: "feature_disabled" }),
        { status: 200 }
      );
    }

    const { data: previewRow, error: previewLookupError } = await supabase
      .from("message_link_previews")
      .select("id, message_id, chat_messages!inner(sender_id, conversation_id)")
      .eq("id", previewId)
      .single();

    if (previewLookupError || !previewRow) {
      return new Response(
        JSON.stringify({ error: "Link preview record not found" }),
        { status: 404 }
      );
    }

    const joinedMessage = Array.isArray(previewRow.chat_messages)
      ? previewRow.chat_messages[0]
      : previewRow.chat_messages;

    const previewContext: PreviewContext = {
      previewId,
      messageId: previewRow.message_id,
      senderId: joinedMessage.sender_id,
      conversationId: joinedMessage.conversation_id,
    };

    const { error: updateError } = await supabase
      .from("message_link_previews")
      .update({
        title: metadata.title || null,
        description: metadata.description || null,
        image_url: metadata.imageUrl || null,
        site_name: metadata.siteName || null,
        fetched_at: new Date().toISOString(),
      })
      .eq("id", previewId);

    if (updateError) {
      console.error("Update error:", updateError);
      await insertAnalyticsSafe(supabase, {
        user_id: previewContext.senderId,
        conversation_id: previewContext.conversationId,
        event_type: "link_preview_failed",
        message_id: previewContext.messageId,
        error_message: updateError.message,
        metadata: { preview_id: previewContext.previewId, url },
      });
      return new Response(JSON.stringify({ error: updateError }), {
        status: 500,
      });
    }

    await insertAnalyticsSafe(supabase, {
      user_id: previewContext.senderId,
      conversation_id: previewContext.conversationId,
      event_type: "link_preview_fetched",
      message_id: previewContext.messageId,
      metadata: {
        preview_id: previewContext.previewId,
        url,
        domain: new URL(url).hostname,
      },
    });

    return new Response(
      JSON.stringify({
        success: true,
        message: `Updated preview for ${previewId}`,
      }),
      { status: 200 }
    );
  } catch (error) {
    console.error("Function error:", error);
    const message = error instanceof Error ? error.message : "Unknown error";
    return new Response(JSON.stringify({ error: message }), {
      status: 500,
    });
  }
});
