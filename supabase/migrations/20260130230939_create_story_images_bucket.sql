insert into storage.buckets (id, name, public)
values ('story-images', 'story-images', true)
on conflict (id) do nothing;

create policy "Public read story images"
on storage.objects for select
using (bucket_id = 'story-images');

create policy "Authenticated upload story images"
on storage.objects for insert
with check (bucket_id = 'story-images' and auth.role() = 'authenticated');
;
