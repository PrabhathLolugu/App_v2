# Supabase Image Upload + URL Mapping Flow

This guide gives you an end-to-end flow to:

1. Upload images to Supabase Storage buckets
2. Generate predictable public URLs
3. Save those URLs into catalog tables
4. Verify everything in app for all map categories

Covered categories:

- Indian Fabrics
- Indian Crafts
- Indian Classical Artforms
- Indian Classical Dances
- Indian Foods by State

---

## Why the catalog tables look “not writable”

Row Level Security (RLS) is enabled on the hub/item tables (`fabric_hubs`, `craft_hubs`, `cultural_state_hubs`, `cultural_state_items`, `food_state_hubs`, `food_state_items`, etc.). Policies allow **public read** of published rows only. There is **no** general `INSERT`/`UPDATE` policy for anonymous or normal signed-in users on those catalog tables (by design: content is curated, not crowd-edited from the app).

That is why the **Table Editor** often shows rows as read-only or rejects saves when the dashboard session is subject to RLS.

**Safe ways to add or change `cover_image_url` / `gallery_urls`:**

1. **Supabase SQL Editor (recommended for one-offs)**  
   Open **SQL** in the project dashboard and run `UPDATE` statements (see examples below). The SQL Editor runs with database privileges that bypass RLS for maintenance, so updates succeed.

2. **New migration in this repo**  
   Add a migration file under `supabase/migrations/` with `UPDATE ... SET cover_image_url = '...', gallery_urls = ...` and apply it with your usual workflow (`supabase db push` or CI). Version-controlled and repeatable.

3. **Service role (scripts only, never in the Flutter app)**  
   Server-side scripts or local tools can use the **service_role** key; that role bypasses RLS. Do **not** ship the service role key in client apps.

4. **Optional: admin-only policies**  
   If you need certain dashboard users to edit via Table Editor without SQL, add narrow `UPDATE` policies (e.g. only for a specific Postgres role or JWT claim). That is a deliberate security change—do not open `UPDATE` to `anon` or all `authenticated` users unless you intend that.

---

## 1) Buckets You Should Use

Create (or confirm) these public buckets in Supabase Storage:

- `fabric-hubs`
- `craft-hubs`
- `cultural-state`
- `state-foods`

> You already used these naming patterns in migrations and fallback data, so keeping them avoids code changes.

---

## 2) Suggested Folder Structure

Use deterministic paths so SQL can be generated automatically.

### A) Fabrics

Bucket: `fabric-hubs`

- `fabric-hubs/{hub_slug}/cover.jpg`
- `fabric-hubs/{hub_slug}/gallery/1.jpg`
- `fabric-hubs/{hub_slug}/gallery/2.jpg`

Example:

- `fabric-hubs/kanchipuram-silk/cover.jpg`
- `fabric-hubs/kanchipuram-silk/gallery/1.jpg`

### B) Crafts

Bucket: `craft-hubs`

- `craft-hubs/{hub_slug}/cover.jpg`
- `craft-hubs/{hub_slug}/gallery/1.jpg`
- `craft-hubs/{hub_slug}/gallery/2.jpg`

### C) Classical Art + Dance

Bucket: `cultural-state`

Use category + state code + item slug:

- `cultural-state/{category}/{state_code_lower}/{item_slug}/cover.jpg`
- `cultural-state/{category}/{state_code_lower}/{item_slug}/gallery/1.jpg`

Where:

- `{category}` = `classical_art` or `classical_dance`
- `{state_code_lower}` example: `ap`, `tn`, `wb` (without `IN-`)
- `{item_slug}` lowercase-kebab-case item name

Example:

- `cultural-state/classical_art/ap/lepakshi-mural-tradition/cover.jpg`
- `cultural-state/classical_dance/tn/bharatanatyam/cover.jpg`

### D) Foods

Bucket: `state-foods`

- `state-foods/{state_code_lower}/{food_slug}/cover.jpg`
- `state-foods/{state_code_lower}/{food_slug}/gallery/1.jpg`

Example:

- `state-foods/tn/sakkarai-pongal/cover.jpg`

---

## 3) Storage Access Policy (Public Read)

If using public buckets via URL, ensure read is allowed.

### Option A (recommended): mark bucket as Public in Dashboard

- Storage -> Bucket -> Settings -> Public bucket = ON

### Option B: RLS policy for storage objects

If you need policy-based read:

```sql
-- Public read on objects for selected buckets
create policy "Public read catalog images"
on storage.objects
for select
to public
using (bucket_id in ('fabric-hubs', 'craft-hubs', 'cultural-state', 'state-foods'));
```

---

## 4) Public URL Format

Base format:

`https://<PROJECT_REF>.supabase.co/storage/v1/object/public/<bucket>/<path>`

In your project, it currently looks like:

`https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/...`

---

## 5) Map URLs Into Tables

## A) Fabrics (`public.fabric_hubs`)

Columns:

- `cover_image_url` (text)
- `gallery_urls` (text[])

Update by slug:

```sql
update public.fabric_hubs
set
  cover_image_url = 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/fabric-hubs/kanchipuram-silk/cover.jpg',
  gallery_urls = array[
    'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/fabric-hubs/kanchipuram-silk/gallery/1.jpg',
    'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/fabric-hubs/kanchipuram-silk/gallery/2.jpg'
  ]::text[]
where slug = 'kanchipuram-silk';
```

## B) Crafts (`public.craft_hubs`)

```sql
update public.craft_hubs
set
  cover_image_url = 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/craft-hubs/channapatna-toys/cover.jpg',
  gallery_urls = array[
    'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/craft-hubs/channapatna-toys/gallery/1.jpg'
  ]::text[]
where slug = 'channapatna-toys';
```

## C) Classical Art + Dance (`public.cultural_state_items`)

Columns:

- `cover_image_url`
- `gallery_urls`

Update by join with hub:

```sql
update public.cultural_state_items i
set
  cover_image_url = concat(
    'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/cultural-state/',
    h.category, '/',
    lower(replace(h.state_code, 'IN-', '')), '/',
    lower(replace(regexp_replace(i.item_name, '[^a-zA-Z0-9]+', '-', 'g'), '--', '-')),
    '/cover.jpg'
  ),
  gallery_urls = array[
    concat(
      'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/cultural-state/',
      h.category, '/',
      lower(replace(h.state_code, 'IN-', '')), '/',
      lower(replace(regexp_replace(i.item_name, '[^a-zA-Z0-9]+', '-', 'g'), '--', '-')),
      '/gallery/1.jpg'
    )
  ]::text[]
from public.cultural_state_hubs h
where i.hub_id = h.id
  and h.category in ('classical_art', 'classical_dance');
```

## D) Foods (`public.food_state_items`)

```sql
update public.food_state_items i
set
  cover_image_url = concat(
    'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/state-foods/',
    lower(replace(h.state_code, 'IN-', '')), '/',
    lower(regexp_replace(i.food_name, '[^a-zA-Z0-9]+', '-', 'g')),
    '/cover.jpg'
  ),
  gallery_urls = array[
    concat(
      'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/state-foods/',
      lower(replace(h.state_code, 'IN-', '')), '/',
      lower(regexp_replace(i.food_name, '[^a-zA-Z0-9]+', '-', 'g')),
      '/gallery/1.jpg'
    )
  ]::text[]
from public.food_state_hubs h
where i.hub_id = h.id;
```

---

## 6) Fast Bulk Flow (Recommended)

1. **Prepare image files locally** with final names (`cover.jpg`, `1.jpg`, `2.jpg`).
2. **Upload folder-by-folder** to the exact paths above.
3. Run the matching **SQL update script** per table.
4. Verify in DB:

```sql
select slug, cover_image_url, gallery_urls
from public.fabric_hubs
order by sort_order
limit 10;
```

```sql
select slug, cover_image_url, gallery_urls
from public.craft_hubs
order by sort_order
limit 10;
```

```sql
select h.category, h.state_code, i.item_name, i.cover_image_url
from public.cultural_state_items i
join public.cultural_state_hubs h on h.id = i.hub_id
order by h.category, h.state_code, i.sort_order
limit 30;
```

```sql
select h.state_code, i.food_name, i.cover_image_url
from public.food_state_items i
join public.food_state_hubs h on h.id = i.hub_id
order by h.sort_order, i.sort_order
limit 30;
```

5. Open app map -> pin -> details and confirm image renders.

---

## 7) Common Issues + Fixes

- **Image not loading**
  - Check object path spelling (`slug`, state code, category segment)
  - Confirm bucket is public or select policy allows read
  - Confirm URL uses `/object/public/` segment

- **Wrong image for item**
  - Re-check slug transformation logic
  - Prefer explicit per-item update for critical entries

- **Blank gallery**
  - Ensure `gallery_urls` is `text[]`, not JSON string
  - Use `array[...]::text[]` syntax in SQL

---

## 8) Optional: Keep an Image Manifest

Create a simple CSV/Sheet with:

- category
- table_name
- key (`slug` or `state_code + item_name`)
- cover_path
- gallery_paths
- last_uploaded_at

This makes future expansions safer and faster.

---

If you want, next I can generate a ready-to-run SQL file that updates **every currently seeded row** from one central path convention (fully automated URL assignment).
