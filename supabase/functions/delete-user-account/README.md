# delete-user-account

Permanently deletes the authenticated user's account and cleans up storage. Called from the app's Settings → Delete Account flow.

**Required:** Deploy this function so in-app account deletion works.

## Deploy

```bash
npx supabase functions deploy delete-user-account --project-ref <YOUR_PROJECT_REF>
```

Example: `npx supabase functions deploy delete-user-account --project-ref xmbygaeixvzlyhbtkbnp`

## Request

- **Method:** POST
- **Headers:** `Authorization: Bearer <user JWT>`
- **Body:** `{ "userId": "<uuid>" }`

The app sends the current user's JWT and id. The function verifies the JWT matches the userId, then deletes storage and the auth user.
