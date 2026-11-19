-- Live demo: alleen bewust gedeelde resultaten; bestaande privégegevens blijven privé.
create table if not exists public.demo_rooms (
 id uuid primary key default gen_random_uuid(),
 owner_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 expires_at timestamptz not null default (now() + interval '12 hours'),
 closed boolean not null default false
);
create table if not exists public.demo_results (
 id uuid primary key default gen_random_uuid(),
 room_id uuid not null references public.demo_rooms(id) on delete cascade,
 user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
 payload jsonb not null check (pg_column_size(payload) < 30000),
 created_at timestamptz not null default now()
);
create index if not exists demo_results_room_time on public.demo_results(room_id,created_at desc);
alter table public.demo_rooms enable row level security;
alter table public.demo_results enable row level security;
revoke all on public.demo_rooms, public.demo_results from public, anon, authenticated;
create or replace function public.demo_create() returns uuid
language plpgsql security definer set search_path = '' as $$
declare r uuid;
begin
 if auth.uid() is null then raise exception 'Log eerst anoniem in'; end if;
 if (select count(*) from public.demo_rooms where owner_id=auth.uid() and expires_at>now()) >= 10 then raise exception 'Maximaal 10 demosessies per 12 uur'; end if;
 insert into public.demo_rooms(owner_id) values(auth.uid()) returning id into r;
 return r;
end $$;
create or replace function public.demo_read(room uuid) returns jsonb
language plpgsql security definer set search_path = '' as $$
begin
 if auth.uid() is null then raise exception 'Log eerst anoniem in'; end if;
 if not exists(select 1 from public.demo_rooms where id=room and expires_at>now() and not closed) then raise exception 'Deze demo is gesloten of verlopen'; end if;
 return coalesce((select jsonb_agg(to_jsonb(t) order by t.created_at desc) from
 (select id,payload,created_at from public.demo_results where room_id=room order by created_at desc limit 200) t),'[]'::jsonb);
end $$;
create or replace function public.demo_submit(room uuid, result jsonb) returns uuid
language plpgsql security definer set search_path = '' as $$
declare r uuid;
begin
 if auth.uid() is null then raise exception 'Log eerst anoniem in'; end if;
 if not exists(select 1 from public.demo_rooms where id=room and expires_at>now() and not closed) then raise exception 'Deze demo is gesloten of verlopen'; end if;
 if jsonb_typeof(result) <> 'object' or pg_column_size(result)>28000 or coalesce(length(result->>'product'),0) not between 1 and 200 or coalesce(length(result->>'slogan'),0) not between 1 and 2000 then raise exception 'Ongeldig demoresultaat'; end if;
 if (select count(*) from public.demo_results where room_id=room and user_id=auth.uid() and created_at>now()-interval '1 minute')>=6 then raise exception 'Wacht even voor je opnieuw deelt'; end if;
 insert into public.demo_results(room_id,user_id,payload) values(room,auth.uid(),result) returning id into r;
 return r;
end $$;
create or replace function public.demo_close(room uuid) returns void
language sql security definer set search_path = '' as $$
 update public.demo_rooms set closed=true where id=room and owner_id=auth.uid();
$$;
revoke all on function public.demo_create(), public.demo_read(uuid), public.demo_submit(uuid,jsonb), public.demo_close(uuid) from public, anon;
grant execute on function public.demo_create(), public.demo_read(uuid), public.demo_submit(uuid,jsonb), public.demo_close(uuid) to authenticated;
notify pgrst, 'reload schema';
