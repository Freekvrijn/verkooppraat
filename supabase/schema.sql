-- VerkoopPraat – geschiedenis per gebruiker (Supabase)
-- Iedere bezoeker logt anoniem in; RLS zorgt dat je alleen je eigen rijen ziet en wijzigt.

create table if not exists public.histories (
  id          text        not null check (char_length(id) between 1 and 40),
  user_id     uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  product     text        not null check (char_length(product) between 1 and 200),
  entry       jsonb       not null check (pg_column_size(entry) < 20000),
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now(),
  primary key (user_id, id)
);

create index if not exists histories_user_updated_idx on public.histories (user_id, updated_at desc);

alter table public.histories enable row level security;

-- Minimale rechten: geen toegang voor niet-ingelogde bezoekers.
revoke all on public.histories from anon, public;
grant select, insert, update, delete on public.histories to authenticated;

drop policy if exists "eigen rijen lezen"      on public.histories;
drop policy if exists "eigen rijen toevoegen"  on public.histories;
drop policy if exists "eigen rijen bijwerken"  on public.histories;
drop policy if exists "eigen rijen verwijderen" on public.histories;

create policy "eigen rijen lezen"       on public.histories for select to authenticated using (user_id = auth.uid());
create policy "eigen rijen toevoegen"   on public.histories for insert to authenticated with check (user_id = auth.uid());
create policy "eigen rijen bijwerken"   on public.histories for update to authenticated using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "eigen rijen verwijderen" on public.histories for delete to authenticated using (user_id = auth.uid());
