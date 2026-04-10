# auth-email-confirm-redirect

Fixes **BG_04**: blank page when clicking the signup email confirmation link.

When the user clicks the confirmation link in the email, Supabase redirects to this HTTPS URL. This function returns an HTML page that:

1. Shows **"Email Verified Successfully"** with app branding (no blank page).
2. Redirects to `myitihas://login-callback` so the app opens and completes sign-in.
3. Adds `from_email_confirm=1` so the app can show an in-app “Email verified successfully” message.

## Required: Enable confirmation emails in Supabase

If new signups are not receiving the verification email:

1. **Turn on "Confirm email"**  
   Dashboard → **Authentication** → **Providers** → **Email** → enable **Confirm email**. Save.

2. **Redirect URL** (see below) must be in the allow list so the confirmation link works.

3. **Custom SMTP for production**  
   Supabase's built-in email only sends to pre-authorized team addresses and is rate-limited. For real users, configure a custom SMTP provider:  
   Dashboard → **Project Settings** → **Auth** → **SMTP Settings** (e.g. Resend, SendGrid, AWS SES).

## Required: Add redirect URL in Supabase

1. Open [Supabase Dashboard](https://supabase.com/dashboard) → your project → **Authentication** → **URL Configuration**.
2. Under **Redirect URLs**, add:
   ```text
   https://<YOUR_PROJECT_REF>.supabase.co/functions/v1/auth-email-confirm-redirect
   ```
   Example: `https://xmbygaeixvzlyhbtkbnp.supabase.co/functions/v1/auth-email-confirm-redirect`
3. Save.

## Deploy

```bash
npx supabase functions deploy auth-email-confirm-redirect --project-ref <YOUR_PROJECT_REF>
```
