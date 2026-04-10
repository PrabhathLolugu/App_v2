-- Backfill best_time_to_visit for common Jyotirlingas and Char Dham
UPDATE "public"."site_details"
SET "best_time_to_visit" = 'May to June and September to October (avoid monsoon)'
WHERE "name" ILIKE '%Kedarnath%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'May to June and September to October (avoid monsoon)'
WHERE "name" ILIKE '%Badrinath%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'May to June and September to October'
WHERE "name" ILIKE '%Gangotri%' OR "name" ILIKE '%Yamunotri%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March (winter months are pleasant)'
WHERE "name" ILIKE '%Kashi Vishwanath%' OR "name" ILIKE '%Varanasi%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March (ideal for coastal climate)'
WHERE "name" ILIKE '%Somnath%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to February (winters are best)'
WHERE "name" ILIKE '%Rameshwaram%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'September to March (pleasant weather)'
WHERE "name" ILIKE '%Dwarka%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March (avoid peak summer)'
WHERE "name" ILIKE '%Puri%' OR "name" ILIKE '%Jagannath%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Mahakaleshwar%' OR "name" ILIKE '%Ujjain%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'September to March'
WHERE "name" ILIKE '%Omkareshwar%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Mallikarjuna%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Bhimashankar%' OR "name" ILIKE '%Trimbakeshwar%' OR "name" ILIKE '%Grishneshwar%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Nageshwar%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Baidyanath%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to May (early mornings are best)'
WHERE "name" ILIKE '%Tirupati%' OR "name" ILIKE '%Venkateswara%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'September to March'
WHERE "name" ILIKE '%Ajanta%' OR "name" ILIKE '%Ellora%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Kamakhya%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Meenakshi%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Brihadeeswarar%';

UPDATE "public"."site_details"
SET "best_time_to_visit" = 'October to March'
WHERE "name" ILIKE '%Hampi%';
