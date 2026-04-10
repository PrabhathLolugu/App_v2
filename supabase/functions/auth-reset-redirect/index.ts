import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { handleOptions } from "../_shared/cors.ts";

/**
 * Auth Reset Redirect - fixes blank page when opening password reset link on Android.
 *
 * Supabase sends the user's browser to this HTTPS URL with ?code=... (PKCE).
 * Browsers often don't hand off custom scheme (myitihas://) to the app and show
 * a blank page. This function returns HTML that:
 * 1. Redirects to myitihas://reset-password?code=... so the app can open
 * 2. Shows an "Open in app" link using Android intent URL as fallback
 *
 * Redirect URL must be added in Supabase Dashboard → Auth → URL Configuration →
 * Redirect URLs: https://<project>.supabase.co/functions/v1/auth-reset-redirect
 */

const APP_SCHEME = "myitihas";
const APP_PACKAGE = "com.myitihas.app";

function escapeHtml(s: string): string {
  return s
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll("\"", "&quot;");
}

function htmlPage(queryString: string): string {
  const q = queryString ? `?${queryString}` : "";
  const deepLinkBase = `${APP_SCHEME}://reset-password${q}`;
  const intentUrl = `intent://reset-password${q}#Intent;scheme=${APP_SCHEME};package=${APP_PACKAGE};end`;
  const safeDeepLinkBase = escapeHtml(deepLinkBase);
  const safeIntentUrl = escapeHtml(intentUrl);

  return `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Open MyItihas</title>
  <script>
    (function() {
      // Preserve both query and hash tokens.
      // Some Supabase auth redirects include tokens in the URL fragment.
      var q = window.location.search || '';
      var h = window.location.hash || '';
      var deepLink = '${APP_SCHEME}://reset-password' + q + h;
      var statusEl = null;

      function setStatus(text) {
        if (!statusEl) {
          statusEl = document.getElementById('status-text');
        }
        if (statusEl) {
          statusEl.textContent = text;
        }
      }

      function setLinks() {
        var appLink = document.getElementById('open-app-link');
        if (appLink) {
          appLink.href = deepLink;
        }
      }

      function tryOpenApp() {
        try {
          // Use hidden iframe so the fallback page remains visible if handoff is blocked.
          var iframe = document.createElement('iframe');
          iframe.style.display = 'none';
          iframe.src = deepLink;
          document.body.appendChild(iframe);
          setTimeout(function() {
            try { document.body.removeChild(iframe); } catch (_) {}
          }, 1200);
          setStatus('If the app did not open, tap the button below.');
        } catch (_) {
          setStatus('Tap the button below to open MyItihas.');
        }
      }

      document.addEventListener('DOMContentLoaded', function () {
        setLinks();
        // Give the page time to render, then attempt deep link.
        setTimeout(tryOpenApp, 150);
      });
    })();
  </script>
  <style>
    body { font-family: system-ui, sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 100vh; margin: 0; padding: 20px; background: #f5f5f5; }
    a { display: inline-block; margin-top: 16px; padding: 14px 24px; background: #2662eb; color: white; text-decoration: none; border-radius: 8px; font-weight: 600; }
    a:hover { opacity: 0.9; }
    p { color: #666; text-align: center; }
  </style>
</head>
<body>
  <p id="status-text">Opening MyItihas app…</p>
  <a id="open-app-link" href="${safeDeepLinkBase}">Open in MyItihas app</a>
  <a href="${safeIntentUrl}">Android fallback</a>
</body>
</html>`;
}

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") {
    return handleOptions();
  }

  if (req.method !== "GET") {
    return new Response("Method not allowed", { status: 405 });
  }

  const url = new URL(req.url);
  const queryString = url.searchParams.toString();

  return new Response(htmlPage(queryString), {
    status: 200,
    headers: {
      "Content-Type": "text/html; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
    },
  });
});
