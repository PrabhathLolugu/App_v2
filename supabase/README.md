# Supabase Configuration for MyItihas

This directory contains the Supabase backend configuration for the MyItihas project.

## Structure

```
supabase/
├── functions/
│   ├── import_map.json          # Shared Deno imports
│   └── generate-story/          # Story generator edge function
│       ├── index.ts             # Main function code
│       ├── README.md            # Function documentation
│       ├── schema.sql           # Database schema
│       ├── function.json        # Function config
│       ├── example-usage.dart   # Flutter integration
│       ├── deploy.sh            # Deployment script
│       └── test-cases.md        # Test scenarios
```

## Quick Start

### 1. Install Supabase CLI

```bash
npm install -g supabase
```

### 2. Login to Supabase

```bash
supabase login
```

### 3. Link to Your Project

```bash
supabase link --project-ref your-project-ref
```

### 4. Set Secrets

```bash
# Get your Gemini API key from https://aistudio.google.com/apikey
supabase secrets set GEMINI_API_KEY=your_gemini_api_key_here
```

### 5. Deploy Edge Function

```bash
cd functions/generate-story
./deploy.sh
```

### 6. Apply Database Schema

Run the SQL in `functions/generate-story/schema.sql` in your Supabase SQL editor.

## Environment Variables

The following environment variables are required:

- `GEMINI_API_KEY` - Your Google Gemini API key (set via secrets)
- `SUPABASE_URL` - Auto-populated by Supabase
- `SUPABASE_SERVICE_ROLE_KEY` - Auto-populated by Supabase

## Edge Functions

### generate-story

Generates educational stories from Indian scriptures using Gemini AI.

**Endpoint**: `https://<project-ref>.supabase.co/functions/v1/generate-story`

**Documentation**: See [functions/generate-story/README.md](functions/generate-story/README.md)

## Local Development

### Start Supabase Locally

```bash
supabase start
```

### Serve Edge Function Locally

```bash
supabase functions serve generate-story --env-file .env.local
```

### Test Locally

```bash
curl -X POST http://localhost:54321/functions/v1/generate-story \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <anon-key>" \
  -d '{"prompt":{"scripture":"Ramayana"},"options":{"length":{"approximateWords":500}}}'
```

## Monitoring

### View Logs

```bash
# Real-time logs
supabase functions logs generate-story --follow

# Historical logs
supabase functions logs generate-story
```

### List Functions

```bash
supabase functions list
```

## Support

For detailed documentation on each edge function, see the README.md in the respective function directory.

## Resources

- [Supabase Edge Functions Documentation](https://supabase.com/docs/guides/functions)
- [Gemini API Documentation](https://ai.google.dev/gemini-api/docs)
- [Deno Documentation](https://deno.land/manual)
