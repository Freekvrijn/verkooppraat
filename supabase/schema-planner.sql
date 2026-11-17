-- VerkoopPraat – contentplanner (iteratie 007)
-- Teksten per kanaal met status en datum. Zelfde aanpak als histories: anonieme login, RLS, alleen eigen rijen.

create table if not exists public.posts (
  id          text        not null check (char_length(id) between 1 and 40),
  user_id     uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  kanaal      text        not null check (kanaal in ('instagram','facebook','linkedin','tiktok','x','googleads','metaads','email','whatsapp')),
  soort       text        not null check (soort in ('slogan','post','pitch','advertentie')),
  status      text        not null default 'concept' check (status in ('concept','klaar','geplaatst')),
  datum       date        not null default current_date,
  data        jsonb       not null check (pg_column_size(data) < 30000),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  primary key (user_id, id)
);

create index if not exists posts_user_datum_idx on public.posts (user_id, datum);

alter table public.posts enable row level security;

revoke all on public.posts from anon, public;
grant select, insert, update, delete on public.posts to authenticated;

drop policy if exists "eigen posts lezen"      on public.posts;
drop policy if exists "eigen posts toevoegen"  on public.posts;
drop policy if exists "eigen posts bijwerken"  on public.posts;
drop policy if exists "eigen posts verwijderen" on public.posts;

create policy "eigen posts lezen"       on public.posts for select to authenticated using (user_id = auth.uid());
create policy "eigen posts toevoegen"   on public.posts for insert to authenticated with check (user_id = auth.uid());
create policy "eigen posts bijwerken"   on public.posts for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "eigen posts verwijderen" on public.posts for delete to authenticated using (user_id = auth.uid());
