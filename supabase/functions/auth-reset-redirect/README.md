# auth-reset-redirect

Fixes **BG_27**: password reset link opening a blank page in the browser instead of the app.

When the user clicks the reset link in email, Supabase redirects to this HTTPS URL with `?code=...`. This function returns a small HTML page that:

1. Immediately redirects to `myitihas://reset-password?code=...` so the app can open.
2. Shows an **"Open in MyItihas app"** link (Android intent URL) if the automatic redirect doesn’t open the app.

## Required: Add redirect URL in Supabase

1. Open [Supabase Dashboard](https://supabase.com/dashboard) → your project → **Authentication** → **URL Configuration**.
2. Under **Redirect URLs**, add:
   ```text
   https://<YOUR_PROJECT_REF>.supabase.co/functions/v1/auth-reset-redirect
   ```
   Example: `https://xmbygaeixvzlyhbtkbnp.supabase.co/functions/v1/auth-reset-redirect`
3. Save.

## Deploy

```bash
npx supabase functions deploy auth-reset-redirect --project-ref <YOUR_PROJECT_REF>
```
