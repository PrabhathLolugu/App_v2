-- Expand classical art catalog with additional state-level artform entities.
-- Adds a second art profile for selected states (same state pin, more list entries).

WITH art_expansion(state_code, item_name, sort_order) AS (
  VALUES
    ('IN-AP','Lepakshi Mural Tradition',2),
    ('IN-AS','Assamese Manuscript Painting',2),
    ('IN-BR','Manjusha Art',2),
    ('IN-CT','Bastar Tribal Wall Art',2),
    ('IN-GJ','Mata ni Pachedi',2),
    ('IN-HP','Chamba Rumal Art',2),
    ('IN-JH','Jadopatia Scroll Art',2),
    ('IN-KA','Karnataka Mysore Ganjifa Art',2),
    ('IN-KL','Kerala Mural Tradition',2),
    ('IN-MP','Bhil Painting',2),
    ('IN-MH','Pinguli Chitrakathi',2),
    ('IN-OR','Tala Pattachitra',2),
    ('IN-PB','Punjab Phulkari Art',2),
    ('IN-RJ','Kishangarh Miniature School',2),
    ('IN-TN','Kolam Ritual Art',2),
    ('IN-TS','Nirmal Painting',2),
    ('IN-UP','Mathura School Visual Tradition',2),
    ('IN-UK','Garhwal Miniature Tradition',2),
    ('IN-WB','Bengal Patachitra',2),
    ('IN-JK','Kashmiri Khatamband Design Art',2)
)
INSERT INTO public.cultural_state_items (
  hub_id,
  item_name,
  short_description,
  about_state_tradition,
  history,
  cultural_significance,
  practice_and_pedagogy,
  performance_context,
  notable_exponents,
  discussion_site_id,
  cover_image_url,
  gallery_urls,
  sort_order,
  is_published
)
SELECT
  h.id,
  a.item_name,
  a.item_name || ' is a state-anchored classical visual tradition with long cultural continuity.',
  a.item_name || ' is mapped at state level for ' || h.state_name || ' to avoid city-level mapping confusion and allow multiple traditions per state.',
  'This artform evolved through temple, court, guild, and community transmission in ' || h.state_name || '.',
  'It preserves regional iconography, visual memory, and inter-generational pedagogy.',
  'Practice is sustained through workshop training, lineage mentorship, and institutional craft schools.',
  'Showcased in state festivals, cultural academies, galleries, and heritage circuits.',
  'Regional gurus, lineage artists, and institutional practitioners.',
  (
    substr(md5(concat(h.state_code, '-', a.item_name, '-art-expansion')), 1, 8) || '-' ||
    substr(md5(concat(h.state_code, '-', a.item_name, '-art-expansion')), 9, 4) || '-' ||
    substr(md5(concat(h.state_code, '-', a.item_name, '-art-expansion')), 13, 4) || '-' ||
    substr(md5(concat(h.state_code, '-', a.item_name, '-art-expansion')), 17, 4) || '-' ||
    substr(md5(concat(h.state_code, '-', a.item_name, '-art-expansion')), 21, 12)
  )::uuid,
  concat(
    'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/cultural-state/classical_art/',
    lower(replace(h.state_code, 'IN-', '')),
    '/',
    lower(replace(replace(a.item_name, ' ', '-'), '''', '')),
    '/cover.jpg'
  ),
  ARRAY[
    concat(
      'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/cultural-state/classical_art/',
      lower(replace(h.state_code, 'IN-', '')),
      '/',
      lower(replace(replace(a.item_name, ' ', '-'), '''', '')),
      '/gallery/1.jpg'
    )
  ]::text[],
  a.sort_order,
  TRUE
FROM art_expansion a
JOIN public.cultural_state_hubs h
  ON h.category = 'classical_art'
 AND h.state_code = a.state_code
ON CONFLICT (discussion_site_id) DO UPDATE SET
  item_name = EXCLUDED.item_name,
  short_description = EXCLUDED.short_description,
  about_state_tradition = EXCLUDED.about_state_tradition,
  history = EXCLUDED.history,
  cultural_significance = EXCLUDED.cultural_significance,
  practice_and_pedagogy = EXCLUDED.practice_and_pedagogy,
  performance_context = EXCLUDED.performance_context,
  notable_exponents = EXCLUDED.notable_exponents,
  cover_image_url = EXCLUDED.cover_image_url,
  gallery_urls = EXCLUDED.gallery_urls,
  sort_order = EXCLUDED.sort_order,
  is_published = EXCLUDED.is_published;

