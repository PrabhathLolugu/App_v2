# Auth Email Setup Checklist (Signup Verification + Forgot Password)

This project requires email verification before login and password reset links that open the app.

If either flow fails, complete this checklist in Supabase Dashboard.

## 1) Enable Email Verification (Required)

1. Open Supabase Dashboard for the project.
2. Go to Authentication -> Providers -> Email.
3. Enable Confirm email.
4. Save.

Expected behavior:
- New signups are not fully authenticated until user verifies email.
- App sign-up flow shows "check your email" message.

## 2) Add Redirect URLs (Required)

Go to Authentication -> URL Configuration -> Redirect URLs and add both:

- https://<YOUR_PROJECT_REF>.supabase.co/functions/v1/auth-email-confirm-redirect
- https://<YOUR_PROJECT_REF>.supabase.co/functions/v1/auth-reset-redirect

Replace <YOUR_PROJECT_REF> with your project ref.

If these are missing, verification/reset links may fail or open wrong pages.

## 3) Configure SMTP (Required for real users)

Go to Project Settings -> Auth -> SMTP Settings and configure a provider
(Resend, SendGrid, SES, etc.).

Without custom SMTP, delivery may be limited or inconsistent.

## 4) Use HTML Email Templates (Hide long raw URLs)

Go to Authentication -> Email Templates and update:

- Confirm Signup template
- Reset Password template

Use HTML content with clickable action buttons using Supabase variable:

- {{ .ConfirmationURL }}

Do not show {{ .ConfirmationURL }} as plain body text. Keep it only in href.

Use the production-ready templates in this repo:

- docs/email-templates/confirm-signup.html
- docs/email-templates/reset-password.html

Logo note:

- Both templates include a logo image tag:
   - src="https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/logo/logo.png"
- Replace this with your final public logo URL if needed.
- Email clients require a public HTTPS image URL (local file paths do not work).

Expected CTA labels:

- Confirm Signup: Confirm Email
- Reset Password: Reset Password

Quick example (Reset Password):

```html
<p>We received a request to reset your password.</p>
<p>
   <a href="{{ .ConfirmationURL }}"
       style="display:inline-block;padding:12px 20px;background:#2662eb;color:#fff;text-decoration:none;border-radius:8px;">
      Reset Password
   </a>
</p>
```

## 5) Deploy Required Edge Functions

From project root:

```bash
npx supabase functions deploy auth-email-confirm-redirect --project-ref <YOUR_PROJECT_REF>
npx supabase functions deploy auth-reset-redirect --project-ref <YOUR_PROJECT_REF>
npx supabase functions deploy forgot-password --project-ref <YOUR_PROJECT_REF>
```

## 6) Set Secrets for Forgot-Password Precheck

Set service role key for the forgot-password function:

```bash
npx supabase secrets set SUPABASE_SERVICE_ROLE_KEY=<YOUR_SERVICE_ROLE_KEY> --project-ref <YOUR_PROJECT_REF>
```

## 7) Verification Test Matrix

Run these after deployment:

1. Signup with new email:
   - App should show verification required message.
   - Login before verification must fail.
2. Click verification mail link:
   - Should open success page, then app.
   - Login should now work.
3. Forgot password with existing email:
   - Should receive HTML email with clickable reset button and no long raw URL text.
4. Forgot password with unknown email:
   - App should show "No account found with this email.".
5. Click reset link:
   - Should open app reset password flow and allow update.

## 8) Troubleshooting

- Redirect URL error: re-check URL Configuration allow-list entries.
- No mail delivered: verify SMTP credentials and sender domain health.
- Plain text/long URL visible: ensure Email Templates are HTML and {{ .ConfirmationURL }} is only used in href (not shown as text).
- Forgot-password check failing: verify SUPABASE_SERVICE_ROLE_KEY secret exists.
