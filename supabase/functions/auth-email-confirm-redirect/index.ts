import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { handleOptions } from "../_shared/cors.ts";

/**
 * Email confirmation redirect - fixes blank page when clicking signup confirmation link (BG_04).
 *
 * Supabase sends the user's browser to this HTTPS URL with tokens (query or fragment).
 * This function returns HTML that:
 * 1. Shows "Email Verified Successfully" and app info (no blank page)
 * 2. Redirects to myitihas://login-callback so the app opens and completes sign-in
 * 3. Adds from_email_confirm=1 so the app can show "Email verified" in-app
 *
 * Add this URL in Supabase Dashboard → Auth → URL Configuration → Redirect URLs:
 * https://<project>.supabase.co/functions/v1/auth-email-confirm-redirect
 */

const APP_SCHEME = "myitihas";
const APP_PACKAGE = "com.myitihas.app";

function htmlPage(): string {
  // Preserve full query and hash; add from_email_confirm=1 so app can show success message.
  // IMPORTANT: avoid immediate location.replace(custom-scheme), which can render a blank page
  // in some Android email/webview clients when scheme handoff is blocked.
  const script = `
    (function() {
      var q = window.location.search ? window.location.search.slice(1) : '';
      var hash = window.location.hash ? window.location.hash.slice(1) : '';
      if (q) q = q + '&from_email_confirm=1'; else q = 'from_email_confirm=1';
      var appLink = '${APP_SCHEME}://login-callback?' + q + (hash ? '#' + hash : '');
      var intentLink = 'intent://login-callback?' + q + (hash ? '#' + hash : '') + '#Intent;scheme=${APP_SCHEME};package=${APP_PACKAGE};end';

      function setStatus(text) {
        var status = document.getElementById('status-text');
        if (status) status.textContent = text;
      }

      function setLinks() {
        var openApp = document.getElementById('open-app');
        var androidFallback = document.getElementById('android-fallback');
        if (openApp) openApp.href = appLink;
        if (androidFallback) androidFallback.href = intentLink;
      }

      function tryOpenApp() {
        try {
          // Use iframe handoff first so the fallback page stays visible if blocked.
          var iframe = document.createElement('iframe');
          iframe.style.display = 'none';
          iframe.src = appLink;
          document.body.appendChild(iframe);
          setTimeout(function() {
            try { document.body.removeChild(iframe); } catch (_) {}
          }, 1200);
          setStatus('If the app did not open, tap "Open in MyItihas app".');
        } catch (_) {
          setStatus('Tap "Open in MyItihas app" to continue.');
        }
      }

      document.addEventListener('DOMContentLoaded', function() {
        setLinks();
        setTimeout(tryOpenApp, 180);
      });
    })();
  `;

  return `<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Email Verified - MyItihas</title>
  <script>${script}</script>
  <style>
    body { font-family: system-ui, sans-serif; display: flex; flex-direction: column; align-items: center; justify-content: center; min-height: 100vh; margin: 0; padding: 24px; background: linear-gradient(180deg, #f0f9ff 0%, #e0f2fe 100%); }
    .card { background: white; border-radius: 16px; padding: 32px; max-width: 360px; box-shadow: 0 4px 24px rgba(0,0,0,0.08); text-align: center; }
    h1 { margin: 0 0 8px; font-size: 1.5rem; color: #0f172a; }
    .sub { color: #64748b; font-size: 0.9375rem; margin-bottom: 16px; }
    .brand { color: #2662eb; font-weight: 600; font-size: 0.875rem; margin-top: 16px; }
    a { display: inline-block; margin-top: 12px; padding: 14px 24px; background: #2662eb; color: white; text-decoration: none; border-radius: 8px; font-weight: 600; }
    a:hover { opacity: 0.9; }
    a.secondary { background: #0f172a; }
    .icon { font-size: 48px; margin-bottom: 16px; }
  </style>
</head>
<body>
  <div class="card">
    <div class="icon" aria-hidden="true">✓</div>
    <h1>Email Verified Successfully</h1>
    <p class="sub" id="status-text">Opening MyItihas app…</p>
    <a id="open-app" href="#">Open in MyItihas app</a>
    <a id="android-fallback" class="secondary" href="#">Android fallback</a>
    <p class="brand">MyItihas</p>
  </div>
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

  return new Response(htmlPage(), {
    status: 200,
    headers: {
      "Content-Type": "text/html; charset=utf-8",
      "Access-Control-Allow-Origin": "*",
    },
  });
});
