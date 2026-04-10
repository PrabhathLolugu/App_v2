# Festival Images Guide

The **Indian Festivals** section and festival detail page use the `image_url` column from the `hindu_festivals` table. When `image_url` is set, the app shows that image in the hero and on cards; when it is null or empty, a placeholder is shown (same behaviour as site images on the map).

---

## Where site images (map screen) are hosted

**Map/site images** are not hardcoded; they come from the database:

- **Tables**: `sacred_locations.image` (list/detail) and `site_details.heroImage` (detail hero). The app uses `data['heroImage'] ?? widget.location.image` for the site detail hero.
- **Hosting**: The app code shows that **Supabase Storage** is used for map-related assets in the **`sacred-sites`** bucket:
  - **Bucket**: `sacred-sites` (public).
  - **Base URL**: `https://<project-ref>.supabase.co/storage/v1/object/public/sacred-sites/`
  - **Examples in code**: Map theme thumbnails (`Standard.png`, `Retro.png`, `Aubergine.png`) and a forum fallback avatar (`userpp.jpg`) use this bucket.

So **site images** are almost certainly either:

1. **Same bucket**: URLs in `sacred_locations.image` / `site_details.heroImage` point to files in **`sacred-sites`**, e.g.  
   `https://<project-ref>.supabase.co/storage/v1/object/public/sacred-sites/kedarnath.jpg`
2. **Or** any other public URL (CDN, etc.) stored in those columns.

To confirm what your project uses: open **Supabase Dashboard** → **Storage** → check if the **sacred-sites** bucket exists and what files it contains. You can use that **same bucket** for festival images (e.g. add a folder `festivals/`) so all app images stay in one place, or create a separate bucket (e.g. `festival-images`) as below.

---

## Where festival images are used

- **Home screen**: Festival cards in the "Indian Festivals" section (horizontal list).
- **Festival detail page**: Hero image at the top (same style as site detail on the map).
- **Festivals list page** ("See all"): List item thumbnails.

All of these read from `hindu_festivals.image_url`. The app uses `CustomImageWidget`, which supports:

- **HTTP/HTTPS URLs**: Any full image URL (e.g. `https://example.com/diwali.jpg`).
- **Empty/null**: Shows the default placeholder (no broken image).

---

## How to add images (two options)

### Option A: Use full image URLs (simplest)

1. Host your images somewhere that returns a **public URL** (e.g. your CDN, Imgur, Unsplash, or any static hosting).
2. Update the `image_url` column in Supabase for each festival.

**In Supabase Dashboard:**

1. Go to **Table Editor** → **hindu_festivals**.
2. Open a row (e.g. Diwali).
3. Set **image_url** to the full URL, e.g.  
   `https://your-cdn.com/festivals/diwali.jpg`  
   or an Unsplash link, e.g.  
   `https://images.unsplash.com/photo-xxx?w=800`
4. Save.

**Using SQL (e.g. in SQL Editor):**

```sql
UPDATE public.hindu_festivals
SET image_url = 'https://your-cdn.com/festivals/diwali.jpg'
WHERE slug = 'diwali';
```

Repeat for other festivals. The app will load these URLs in the hero and on cards.

---

### Option B: Use Supabase Storage (like site/story images)

You can use the **existing `sacred-sites` bucket** (same as map site images) or create a new bucket.

**Using the existing `sacred-sites` bucket (recommended if you already use it for sites):**

1. In **Supabase Dashboard** → **Storage** → open the **sacred-sites** bucket.
2. Create a folder (e.g. **festivals**).
3. Upload festival images (e.g. `diwali.jpg`, `holi.jpg`) into that folder.
4. Copy each file’s **Public URL**. It will look like:  
   `https://<project-ref>.supabase.co/storage/v1/object/public/sacred-sites/festivals/diwali.jpg`
5. Set `hindu_festivals.image_url` to that URL (Table Editor or SQL as in Option A).

**Or create a new bucket (e.g. `festival-images`):**

#### 1. Create a storage bucket (one-time)

In **Supabase Dashboard** → **Storage**:

- Click **New bucket**.
- Name: `festival-images` (or any name you prefer).
- **Public bucket**: turn ON so the app can show images without auth.
- Create the bucket.

#### 2. Add a policy for public read

In **Storage** → **Policies** for `festival-images`:

- **New policy** → “For full customization”.
- Policy name: e.g. `Public read festival images`.
- Allowed operation: **SELECT (read)**.
- Target: bucket `festival-images`.
- USING expression: `true` (allow all reads).

Optionally add an **INSERT** policy for authenticated users (or service role) so you can upload via the dashboard or API.

#### 3. Upload images

- Open the `festival-images` bucket.
- Create a folder if you want (e.g. `festivals`).
- Upload image files (e.g. `diwali.jpg`, `holi.jpg`).
- After upload, open the file and copy its **Public URL** (e.g.  
  `https://<project-ref>.supabase.co/storage/v1/object/public/festival-images/festivals/diwali.jpg`).

#### 4. Save the URL in the database

Set `hindu_festivals.image_url` to that public URL (same as Option A):

- Either in **Table Editor** for the row, or  
- With SQL:

```sql
UPDATE public.hindu_festivals
SET image_url = 'https://<project-ref>.supabase.co/storage/v1/object/public/festival-images/festivals/diwali.jpg'
WHERE slug = 'diwali';
```

Replace `<project-ref>` with your Supabase project reference.

---

## Image guidelines

- **Aspect ratio**: Landscape (e.g. 16:9 or 4:3) works best for the hero and cards.
- **Size**: Around 800–1200px wide is enough for good quality without huge file size.
- **Format**: JPEG or WebP for photos; PNG if you need transparency.

---

## Summary

| Goal                         | Action                                                                 |
|-----------------------------|-------------------------------------------------------------------------|
| Use images from the internet | Set `image_url` to a full HTTPS URL (Option A).                         |
| Store images in your project| Create a public Supabase Storage bucket, upload files, set `image_url` to each file’s public URL (Option B). |
| No image for a festival     | Leave `image_url` null or empty; the app shows the default placeholder. |

The app does **not** need code changes to support either option; it only needs valid URLs in `image_url`.
