-- Allow public (including anonymous) to read featured stories
CREATE POLICY "Anyone can read featured stories"
ON public.generated_stories
FOR SELECT
TO public
USING (is_featured = true);;
