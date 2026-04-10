# Deploy Edge Functions to Supabase

## How the .ts files are structured

```
supabase/functions/
├── _shared/              ← Shared code (NOT standalone functions)
│   ├── prompts.ts        ← Used by chat-service, generate-story, etc.
│   ├── types.ts
│   ├── openrouter.ts
│   ├── cors.ts
│   └── ...
├── chat-service/
│   └── index.ts          ← Entry point (imports from _shared)
├── generate-story/
│   └── index.ts
├── translation/
│   └── index.ts
└── ...
```

**Important:** The `_shared/` folder contains modules imported by the functions. When you deploy with the CLI, each function is bundled with its `../_shared/...` imports, so those .ts files are included automatically. You do **not** deploy `_shared` separately.

---

## Available Edge Functions

Your project has these Edge Functions in `supabase/functions/`:

| Function | Purpose |
|----------|---------|
| `generate-travel-plan` | AI spiritual pilgrimage plan (OpenRouter) |
| `translation` | Translate stories to Indian languages |
| `generate-story` | Generate stories from scriptures |
| `generate-image` | Generate story images |
| `edge-tts` | Cloud Indic text-to-speech for stories |
| `interact-with-story` | Story interaction |
| `chat-service` | Chat service |
| `delete-user-account` | Delete user account |
| `forgot-password` | Verify whether email is registered for reset flow |
| `auth-reset-redirect` | Browser-to-app handoff page for reset links |
| `send-push-notification` | FCM push notifications |
| `migrate-base64-images` | One-off image migration |

---

## Option A: Deploy via Supabase CLI (recommended)

### 1. Install Supabase CLI

**Global npm install is not supported.** Use one of these:

**Option 1 – Project install with npx (recommended, you have Node.js):**
```powershell
cd "c:\Users\p2040\Downloads\MyItihas-main (1)\MyItihas-main"
npm init -y
npm install supabase --save-dev
```
Then run all Supabase commands with `npx supabase` instead of `supabase` (e.g. `npx supabase login`, `npx supabase functions deploy`).

**Option 2 – Direct download (no Node needed):**
1. Open https://github.com/supabase/cli/releases
2. Download the latest `supabase_windows_amd64.zip`
3. Unzip and put `supabase.exe` in a folder (e.g. `C:\Tools`)
4. Either add that folder to your PATH, or run it with full path: `C:\Tools\supabase.exe --version`

**Option 3 – Scoop (if you install Scoop first):**
```powershell
# Install Scoop first (PowerShell as Admin):
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
# Then:
scoop bucket add supabase https://github.com/supabase/scoop-bucket.git
scoop install supabase
```

### 2. Log in and link your project

```powershell
cd "c:\Users\p2040\Downloads\MyItihas-main (1)\MyItihas-main"
npx supabase login
npx supabase link --project-ref YOUR_PROJECT_REF
```
*(If you used direct download or Scoop, use `supabase` instead of `npx supabase`.)*

Get `YOUR_PROJECT_REF` from the dashboard URL:  
`https://supabase.com/dashboard/project/YOUR_PROJECT_REF`

### 3. Set secrets (if not already set)

```powershell
npx supabase secrets set OPENROUTER_API_KEY=your_openrouter_key_here
```

Other functions may need:
- `FIREBASE_PROJECT_ID`, `FIREBASE_SERVICE_ACCOUNT_JSON` for `send-push-notification`

### 4. Deploy all functions

```powershell
npx supabase functions deploy
```

Or deploy one at a time:

```powershell
npx supabase functions deploy generate-travel-plan
npx supabase functions deploy translation
npx supabase functions deploy generate-story
npx supabase functions deploy edge-tts
```

---

## Option B: Deploy via Supabase Dashboard

For each function you want to add:

1. Go to **Supabase Dashboard** → **Edge Functions** → **Create a new function**.
2. **Function name:** use the folder name (e.g. `generate-travel-plan`).
3. **Code:** Copy the full contents of `supabase/functions/<name>/index.ts` into the editor.
   - **Note:** Only `generate-travel-plan` is self-contained (no `_shared` imports). The others import `../_shared/...`, so they will **fail to deploy** from the dashboard unless you use the CLI (Option A) or inline their shared code too.
4. Under **Project Settings** → **Edge Functions** → **Secrets**, add `OPENROUTER_API_KEY`.
5. Click **Deploy function**.

**Recommendation:** Use **Option A (CLI)** so all functions (and the `_shared` folder) deploy correctly.

---

## Adding a new Edge Function

To add a new edge function:

1. **Create a folder** under `supabase/functions/` with your function name (e.g. `my-new-function`).

2. **Create `index.ts`** as the entry point:

```ts
import "jsr:@supabase/functions-js/edge-runtime.d.ts";
import { createSupabaseClient } from "../_shared/supabase.ts";
import { errorResponse, handleOptions, jsonResponse } from "../_shared/cors.ts";

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return handleOptions();

  try {
    const body = await req.json();
    // Your logic here
    return jsonResponse({ ok: true });
  } catch (e) {
    return errorResponse(String(e), 500);
  }
});
```

3. **(Optional)** Add `deno.json` if you need npm/jsr imports:

```json
{"imports":{"@supabase/supabase-js":"jsr:@supabase/supabase-js@2"}}
```

4. **Deploy:**
```powershell
npx supabase functions deploy my-new-function
```

The new function will automatically bundle any `../_shared/` imports when deployed.
