-- Expand craft catalog with additional hubs and sellers.

INSERT INTO public.craft_hubs (
    id, slug, name, region, state, latitude, longitude, craft_name,
    short_description, about_place_and_craft, history, cultural_significance,
    making_process, materials, motifs_and_style, care_and_authenticity,
    best_buying_season, cover_image_url, gallery_urls, discussion_site_id,
    sort_order, is_published
) VALUES
('7b8aa801-a1f1-4a5f-a001-000000000021','tholu-bommalata-craft','Nimmalakunta','Andhra Pradesh','Andhra Pradesh',14.2500,77.9500,'Tholu Bommalata Leather Craft','Painted translucent leather puppetry craft linked to shadow theatre traditions.','Nimmalakunta artisans process leather and paint mythic figures for performance and decorative formats.','The craft is rooted in itinerant storytelling and temple-festival performance circuits.','It preserves oral-epic performance memory and visual pedagogy traditions.','Leather treatment, stencil transfer, hand painting, perforation and finishing.','Processed leather, natural/synthetic pigments, thread and rods.','Epic figures, ornate costume detailing, perforated light effects.','Verify artisan provenance and avoid printed replicas marketed as hand-painted.', 'October-February', 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/craft-hubs/tholu-bommalata-craft/cover.jpg', '{}'::text[], '7b8aa801-a1f1-4a5f-b001-000000000021',21,TRUE),
('7b8aa801-a1f1-4a5f-a001-000000000022','molela-terracotta','Molela','Rajasthan','Rajasthan',24.6200,73.9200,'Molela Terracotta Plaques','Relief terracotta devotional plaques used in shrine and household settings.','Molela potter families produce hand-moulded plaques depicting local deities and folk icons.','The craft evolved around pilgrimage routes and ritual object demand in western India.','Molela plaques support ritual continuity in rural and tribal communities.','Clay kneading, slab relief modelling, carving, drying, kiln firing, pigment wash.','Terracotta clay, mineral pigments, traditional kilns.','Bold relief deity forms and narrative panels.','Inspect firing and edge strength for larger plaques.', 'November-March', 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/craft-hubs/molela-terracotta/cover.jpg', '{}'::text[], '7b8aa801-a1f1-4a5f-b001-000000000022',22,TRUE),
('7b8aa801-a1f1-4a5f-a001-000000000023','sikki-grass-craft','Madhubani','Bihar','Bihar',26.3500,86.0700,'Sikki Grass Craft','Coiled and stitched golden-grass utility and ceremonial craft items.','Sikki artisans produce baskets, boxes, and ritual products using dried grass and hand stitching.','The craft is sustained by women-led household production systems across Mithila.','Sikki work represents sustainable craft and seasonal livelihood support.','Grass processing, coiling, stitching, shape formation, color detailing.','Sikki grass, munj fiber, natural/synthetic colors.','Coiled geometry, floral patterns, utility miniatures.','Keep away from moisture and prolonged compression.', 'October-February', 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/craft-hubs/sikki-grass-craft/cover.jpg', '{}'::text[], '7b8aa801-a1f1-4a5f-b001-000000000023',23,TRUE),
('7b8aa801-a1f1-4a5f-a001-000000000024','bamboo-boat-craft','Agartala','Tripura','Tripura',23.8315,91.2868,'Tripura Bamboo Craft','Bamboo-cane weaving and assembled craft utility products from indigenous clusters.','Tripura artisans create home utility and decorative objects using local bamboo and cane.','Traditional bamboo skills evolved through forest-linked community material culture.','The craft supports sustainable design and local livelihood economies.','Splitting, weaving, bending, lashing, surface finishing and treatment.','Bamboo, cane, natural binders, local dyes.','Geometric basketry and functional household forms.','Choose treated products with consistent weaving tension.', 'September-February', 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/craft-hubs/bamboo-boat-craft/cover.jpg', '{}'::text[], '7b8aa801-a1f1-4a5f-b001-000000000024',24,TRUE)
ON CONFLICT (id) DO UPDATE SET
    slug = EXCLUDED.slug,
    name = EXCLUDED.name,
    region = EXCLUDED.region,
    state = EXCLUDED.state,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    craft_name = EXCLUDED.craft_name,
    short_description = EXCLUDED.short_description,
    about_place_and_craft = EXCLUDED.about_place_and_craft,
    history = EXCLUDED.history,
    cultural_significance = EXCLUDED.cultural_significance,
    making_process = EXCLUDED.making_process,
    materials = EXCLUDED.materials,
    motifs_and_style = EXCLUDED.motifs_and_style,
    care_and_authenticity = EXCLUDED.care_and_authenticity,
    best_buying_season = EXCLUDED.best_buying_season,
    cover_image_url = EXCLUDED.cover_image_url,
    gallery_urls = EXCLUDED.gallery_urls,
    discussion_site_id = EXCLUDED.discussion_site_id,
    sort_order = EXCLUDED.sort_order,
    is_published = EXCLUDED.is_published;

INSERT INTO public.craft_sellers (
    craft_hub_id, seller_name, organization, seller_type, contact_line,
    website, city, is_featured, display_order
)
SELECT ch.id, s.seller_name, s.organization, s.seller_type, s.contact_line, s.website, s.city, s.is_featured, s.display_order
FROM (
    VALUES
      ('tholu-bommalata-craft','AP Lepakshi','Andhra Pradesh Handicrafts Development','government','State handicrafts guidance and retail','https://www.aplepakshi.com','Anantapur',TRUE,1),
      ('molela-terracotta','Rajasthan Craft Promotion','State-supported artisan sales channel','government','Molela craft counters and exhibitions','https://www.rajasthan.gov.in','Udaipur',FALSE,1),
      ('sikki-grass-craft','Mithila Women Artisan Collective','Registered women-led craft group','cooperative','Sikki craft cluster retail and support',NULL,'Madhubani',TRUE,1),
      ('bamboo-boat-craft','Tripura Bamboo Mission','State bamboo craft support channel','government','Bamboo craft linkage and retail support',NULL,'Agartala',TRUE,1)
) AS s(slug, seller_name, organization, seller_type, contact_line, website, city, is_featured, display_order)
JOIN public.craft_hubs ch ON ch.slug = s.slug
ON CONFLICT DO NOTHING;

