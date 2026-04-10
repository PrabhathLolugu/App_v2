# forgot-password

Checks if an email is registered before sending a password reset (so the app can show "No account found" for unregistered emails).

## Deploy

```bash
supabase functions deploy forgot-password --project-ref xmbygaeixvzlyhbtkbnp
```

Or with your project ref:

```bash
supabase functions deploy forgot-password --project-ref <YOUR_PROJECT_REF>
```

## Invoke (test)

```bash
curl -L -X POST 'https://xmbygaeixvzlyhbtkbnp.supabase.co/functions/v1/forgot-password' \
  -H 'Authorization: Bearer [YOUR_ANON_KEY]' \
  -H 'Content-Type: application/json' \
  -d '{"email":"user@example.com"}'
```

Replace `[YOUR_ANON_KEY]` with your project's anon (public) key from **Project Settings → API**.

- Registered email → `{"registered":true}`
- Unregistered email → `{"registered":false}`
