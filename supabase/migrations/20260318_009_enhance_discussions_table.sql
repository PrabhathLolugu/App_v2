-- Migration: Enhance discussions table with site name and category
-- Date: 2026-03-18
-- Description: Adds site_name and category columns with proper defaults and indexes

-- Ensure site_name and category columns exist
ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS site_name TEXT;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS preview TEXT;

ALTER TABLE IF EXISTS public.discussions
ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'general';

-- Create index for category filtering
CREATE INDEX IF NOT EXISTS idx_discussions_category ON public.discussions(category);

-- Create index for site_name lookups
CREATE INDEX IF NOT EXISTS idx_discussions_site_name ON public.discussions(site_name);

-- Function to auto-fill preview from content when content is updated
CREATE OR REPLACE FUNCTION auto_fill_discussion_preview()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.content IS NOT NULL AND (NEW.preview IS NULL OR NEW.preview = '') THEN
        NEW.preview := CASE
            WHEN LENGTH(NEW.content) > 200 THEN SUBSTRING(NEW.content, 1, 200) || '...'
            ELSE NEW.content
        END;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Drop trigger if exists, then create new one
DROP TRIGGER IF EXISTS trigger_auto_fill_discussion_preview ON public.discussions;
CREATE TRIGGER trigger_auto_fill_discussion_preview
    BEFORE INSERT OR UPDATE ON public.discussions
    FOR EACH ROW
    EXECUTE FUNCTION auto_fill_discussion_preview();

-- Update existing discussions to have preview if not set
UPDATE public.discussions
SET preview = CASE
    WHEN LENGTH(content) > 200 THEN SUBSTRING(content, 1, 200) || '...'
    ELSE content
END
WHERE preview IS NULL OR preview = '';

-- Set default category for existing rows
UPDATE public.discussions
SET category = 'general'
WHERE category IS NULL;

-- Note: site_name is populated by the application when creating discussions
-- If heritage_sites table exists in future, uncomment this:
-- UPDATE public.discussions d
-- SET site_name = (
--     SELECT name FROM public.heritage_sites hs WHERE hs.id = d.site_id
-- )
-- WHERE d.site_id IS NOT NULL AND d.site_name IS NULL;
