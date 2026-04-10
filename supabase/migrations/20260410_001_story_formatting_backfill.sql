-- Backfill legacy story formatting fields from metadata -> attributes
-- and normalize escaped newline sequences in stored text fields.

begin;

update stories
set attributes = coalesce(attributes, '{}'::jsonb)
where attributes is null;

update stories
set attributes = jsonb_set(
  attributes,
  '{trivia}',
  to_jsonb(
    replace(
      replace(
        replace(
          replace(
            replace(
              coalesce(
                nullif(attributes ->> 'trivia', ''),
                nullif(metadata ->> 'trivia', ''),
                ''
              ),
              E'\\r\\n',
              E'\n'
            ),
            E'\\n',
            E'\n'
          ),
          E'\\r',
          E'\n'
        ),
        E'\r\n',
        E'\n'
      ),
      E'\r',
      E'\n'
    )
  ),
  true
)
where coalesce(nullif(attributes ->> 'trivia', ''), nullif(metadata ->> 'trivia', '')) is not null;

update stories
set attributes = jsonb_set(
  attributes,
  '{moral}',
  to_jsonb(
    replace(
      replace(
        replace(
          replace(
            replace(
              coalesce(
                nullif(attributes ->> 'moral', ''),
                nullif(metadata ->> 'lesson', ''),
                ''
              ),
              E'\\r\\n',
              E'\n'
            ),
            E'\\n',
            E'\n'
          ),
          E'\\r',
          E'\n'
        ),
        E'\r\n',
        E'\n'
      ),
      E'\r',
      E'\n'
    )
  ),
  true
)
where coalesce(nullif(attributes ->> 'moral', ''), nullif(metadata ->> 'lesson', '')) is not null;

update stories
set attributes = jsonb_set(
  attributes,
  '{quotes}',
  to_jsonb(coalesce(nullif(attributes ->> 'quotes', ''), nullif(metadata ->> 'quotes', ''), '')),
  true
)
where coalesce(nullif(attributes ->> 'quotes', ''), nullif(metadata ->> 'quotes', '')) is not null;

update stories
set attributes = jsonb_set(
  attributes,
  '{activity}',
  to_jsonb(coalesce(nullif(attributes ->> 'activity', ''), nullif(metadata ->> 'activity', ''), '')),
  true
)
where coalesce(nullif(attributes ->> 'activity', ''), nullif(metadata ->> 'activity', '')) is not null;

update stories
set attributes = jsonb_set(
  attributes,
  '{scripture}',
  to_jsonb(coalesce(nullif(attributes ->> 'scripture', ''), nullif(metadata ->> 'scripture', ''), '')),
  true
)
where coalesce(nullif(attributes ->> 'scripture', ''), nullif(metadata ->> 'scripture', '')) is not null;

update stories
set content = replace(
  replace(
    replace(
      replace(
        replace(content, E'\\r\\n', E'\n'),
        E'\\n',
        E'\n'
      ),
      E'\\r',
      E'\n'
    ),
    E'\r\n',
    E'\n'
  ),
  E'\r',
  E'\n'
)
where content is not null
  and (
    content like E'%\\r\\n%'
    or content like E'%\\n%'
    or content like E'%\\r%'
    or content like E'%\r\n%'
    or content like E'%\r%'
  );

commit;
