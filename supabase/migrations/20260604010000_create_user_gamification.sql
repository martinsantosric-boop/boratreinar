create extension if not exists pgcrypto;

create table if not exists public.user_gamification (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  total_xp integer not null default 0,
  total_km numeric(10, 2) not null default 0,
  current_streak integer not null default 0,
  longest_streak integer not null default 0,
  last_run_date timestamptz,
  achievements jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id)
);

alter table public.user_gamification enable row level security;

grant select, insert, update on public.user_gamification to authenticated;

drop policy if exists "Users can view all gamification data"
on public.user_gamification;

create policy "Users can view all gamification data"
on public.user_gamification
for select
to authenticated
using (true);

drop policy if exists "Users can insert their own gamification data"
on public.user_gamification;

create policy "Users can insert their own gamification data"
on public.user_gamification
for insert
to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Users can update their own gamification data"
on public.user_gamification;

create policy "Users can update their own gamification data"
on public.user_gamification
for update
to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);

drop trigger if exists set_user_gamification_updated_at
on public.user_gamification;

create trigger set_user_gamification_updated_at
before update on public.user_gamification
for each row
execute function public.set_updated_at();

create index if not exists idx_user_gamification_total_xp
on public.user_gamification (total_xp desc);

create index if not exists idx_user_gamification_user_id
on public.user_gamification (user_id);

create or replace view public.leaderboard as
select
  p.id,
  p.email,
  p.full_name,
  p.avatar_url,
  ug.total_xp,
  ug.total_km,
  ug.current_streak,
  case
    when ug.total_xp >= 15000 then 'legendary'
    when ug.total_xp >= 7000 then 'diamond'
    when ug.total_xp >= 3000 then 'gold'
    when ug.total_xp >= 1000 then 'silver'
    else 'bronze'
  end as league,
  row_number() over (order by ug.total_xp desc, ug.total_km desc, p.created_at asc) as rank
from public.profiles p
join public.user_gamification ug on ug.user_id = p.id
order by ug.total_xp desc, ug.total_km desc, p.created_at asc;

grant select on public.leaderboard to authenticated;
