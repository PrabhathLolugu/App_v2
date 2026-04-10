-- Create storage bucket for post media
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'post-media', 
    'post-media', 
    true,
    52428800, -- 50MB limit
    ARRAY['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'video/mp4', 'video/webm', 'video/quicktime']
);

-- RLS policies for post-media bucket
-- Users can upload to their own folder (folder name = user_id)
CREATE POLICY "Users can upload own post media"
ON storage.objects FOR INSERT
WITH CHECK (
    bucket_id = 'post-media' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- Anyone can view post media (public bucket)
CREATE POLICY "Anyone can view post media"
ON storage.objects FOR SELECT
USING (bucket_id = 'post-media');

-- Users can update their own media
CREATE POLICY "Users can update own post media"
ON storage.objects FOR UPDATE
USING (
    bucket_id = 'post-media' AND
    auth.uid()::text = (storage.foldername(name))[1]
);

-- Users can delete their own media
CREATE POLICY "Users can delete own post media"
ON storage.objects FOR DELETE
USING (
    bucket_id = 'post-media' AND
    auth.uid()::text = (storage.foldername(name))[1]
);;
