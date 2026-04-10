-- Expand fabric catalog with additional prominent hubs and sellers.

INSERT INTO public.fabric_hubs (
    id, slug, name, region, state, latitude, longitude,
    fabric_name, short_description, about_place_and_fabric, history,
    cultural_significance, weaving_process, motifs_and_design,
    care_and_authenticity, best_buying_season, cover_image_url, gallery_urls,
    discussion_site_id, sort_order, is_published
) VALUES
('b8a9ef95-4894-49bf-bafb-c88831f8fb01','balrampuram-handloom','Balaramapuram','Kerala','Kerala',8.4290,77.0520,
 'Balaramapuram Handloom','Fine cotton handloom known for kasavu borders and ceremonial wear.',
 'Balaramapuram is a long-running weaving settlement producing temple-oriented veshti and set mundu formats.',
 'The weave was promoted in Travancore-era weaving networks and remains a heritage craft economy.',
 'Kasavu-bordered handlooms are deeply tied to Kerala ritual and festive wardrobes.',
 'Handloom cotton is woven in narrow and broad widths with zari-kasavu edge planning.',
 'White and off-white bodies with elegant gold borders define classic products.',
 'Verify genuine handloom tags and buy from cooperative channels.',
 'October-February',
 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/fabric-hubs/balrampuram-handloom/cover.jpg',
 '{}'::text[],
 '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a31',23,TRUE),
('b8a9ef95-4894-49bf-bafb-c88831f8fb02','ilkal-saree','Ilkal','Karnataka','Karnataka',15.9600,76.1300,
 'Ilkal Saree','Traditional drape with contrast pallu and tope teni technique.',
 'Ilkal weaving clusters are known for region-specific saree structures and practical elegance.',
 'The craft evolved through local weaving guilds and regional cotton-silk trade.',
 'Ilkal sarees remain part of ceremonial and everyday traditional attire in Karnataka.',
 'Distinctive body-border-pallu joining methods create durable and recognizable weave identity.',
 'Temple borders, checks, and contrast pallus are widely seen.',
 'Prefer cooperative and state-certified sales points for authentic weave quality.',
 'October-March',
 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/fabric-hubs/ilkal-saree/cover.jpg',
 '{}'::text[],
 '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a32',24,TRUE),
('b8a9ef95-4894-49bf-bafb-c88831f8fb03','kullu-shawl','Kullu','Himachal Pradesh','Himachal Pradesh',31.9600,77.1100,
 'Kullu Shawl','Woollen shawls with geometric woven borders and mountain motifs.',
 'Kullu weaving communities produce warm handloom shawls using local and blended wool.',
 'The tradition grew through Himalayan household weaving and winter textile exchange.',
 'Kullu shawls are symbols of Himachali identity and ceremonial gifting.',
 'Loom weaving emphasizes plain body with richly patterned border panels.',
 'Angular geometric border language is the visual hallmark.',
 'Check wool composition and weave density from trusted craft outlets.',
 'November-February',
 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/fabric-hubs/kullu-shawl/cover.jpg',
 '{}'::text[],
 '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a33',25,TRUE),
('b8a9ef95-4894-49bf-bafb-c88831f8fb04','bagru-block-print','Bagru','Rajasthan','Rajasthan',26.8100,75.5500,
 'Bagru Block Print','Natural-dye hand block printing with resist and mud treatment methods.',
 'Bagru printing uses hand-carved blocks and vegetable/mineral dyes for earthy textile surfaces.',
 'Craft families preserved block-making and printing through intergenerational workshops.',
 'Bagru remains central to Rajasthan textile identity in apparel and home linen.',
 'Fabric pre-treatment, block printing, dyeing, washing, and sun curing define production.',
 'Floral buta, geometric repeats, and earthy indigo-madder combinations dominate designs.',
 'Expect artisanal variation and avoid aggressive detergents.',
 'October-February',
 'https://xmbygaeixvzlyhbtkbnp.supabase.co/storage/v1/object/public/fabric-hubs/bagru-block-print/cover.jpg',
 '{}'::text[],
 '8f0e3a2b-7c1d-4e5f-9a0b-1c2d3e4f5a34',26,TRUE)
ON CONFLICT (id) DO UPDATE SET
    slug = EXCLUDED.slug,
    name = EXCLUDED.name,
    region = EXCLUDED.region,
    state = EXCLUDED.state,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    fabric_name = EXCLUDED.fabric_name,
    short_description = EXCLUDED.short_description,
    about_place_and_fabric = EXCLUDED.about_place_and_fabric,
    history = EXCLUDED.history,
    cultural_significance = EXCLUDED.cultural_significance,
    weaving_process = EXCLUDED.weaving_process,
    motifs_and_design = EXCLUDED.motifs_and_design,
    care_and_authenticity = EXCLUDED.care_and_authenticity,
    best_buying_season = EXCLUDED.best_buying_season,
    cover_image_url = EXCLUDED.cover_image_url,
    gallery_urls = EXCLUDED.gallery_urls,
    discussion_site_id = EXCLUDED.discussion_site_id,
    sort_order = EXCLUDED.sort_order,
    is_published = EXCLUDED.is_published;

INSERT INTO public.fabric_sellers (
    fabric_hub_id, seller_name, organization, seller_type,
    contact_line, website, city, is_featured, display_order
)
SELECT h.id, s.seller_name, s.organization, s.seller_type, s.contact_line, s.website, s.city, s.is_featured, s.display_order
FROM (
    VALUES
      ('balrampuram-handloom','Hantex','Kerala State Handloom Weavers Co-operative','cooperative','Official Kerala handloom channels','https://www.hantex.org','Thiruvananthapuram',TRUE,1),
      ('ilkal-saree','Karnataka State Handloom Outlet','State handloom retail','government','Ilkal saree curated counters','https://karnataka.gov.in','Bengaluru',FALSE,1),
      ('kullu-shawl','Himachal Handloom Sales Centre','State handloom and handicrafts channel','government','Wool handloom products and certifications',NULL,'Kullu',TRUE,1),
      ('bagru-block-print','Rajasthan Craft Cooperative','Registered artisan print cluster','cooperative','Bagru block print certified artisan group',NULL,'Bagru',TRUE,1)
) AS s(slug, seller_name, organization, seller_type, contact_line, website, city, is_featured, display_order)
JOIN public.fabric_hubs h ON h.slug = s.slug
ON CONFLICT DO NOTHING;

