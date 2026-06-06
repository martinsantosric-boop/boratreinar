-- ============================================
-- SCRIPT PARA CRIAR TABELAS E VIEWS NO SUPABASE
-- Execute este SQL no Supabase SQL Editor
-- ============================================

-- 1. Criar tabela user_gamification
-- ============================================

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

-- 2. Configurar RLS (Row Level Security)
-- ============================================

alter table public.user_gamification enable row level security;

grant select, insert, update on public.user_gamification to authenticated;

-- Garantir coluna de sexo usada pelo perfil do app
alter table public.profiles
add column if not exists gender text;

-- 3. Criar políticas de acesso
-- ============================================

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

-- 4. Criar função e trigger para updated_at
-- ============================================

create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

drop trigger if exists set_user_gamification_updated_at
on public.user_gamification;

create trigger set_user_gamification_updated_at
before update on public.user_gamification
for each row
execute function public.set_updated_at();

-- 5. Criar índices para performance
-- ============================================

create index if not exists idx_user_gamification_total_xp
on public.user_gamification (total_xp desc);

create index if not exists idx_user_gamification_user_id
on public.user_gamification (user_id);

-- 6. Criar VIEW do leaderboard/ranking
-- ============================================

drop view if exists public.leaderboard;

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

-- 7. Criar função para inicializar gamificação do usuário
-- ============================================

create or replace function public.initialize_user_gamification()
returns trigger as $$
begin
  insert into public.user_gamification (user_id)
  values (new.id)
  on conflict (user_id) do nothing;
  return new;
end;
$$ language plpgsql security definer;

-- 8. Criar trigger para inicializar automaticamente ao criar perfil
-- ============================================

drop trigger if exists on_profile_created_init_gamification on public.profiles;

create trigger on_profile_created_init_gamification
after insert on public.profiles
for each row
execute function public.initialize_user_gamification();

-- ============================================
-- VERIFICAÇÃO - Execute após criar tudo acima
-- ============================================

-- Ver estrutura da tabela
-- select * from information_schema.columns 
-- where table_name = 'user_gamification';

-- Ver se a view foi criada
-- select * from information_schema.views 
-- where table_name = 'leaderboard';

-- Testar a view (deve retornar vazio se não houver dados)
-- select * from public.leaderboard limit 5;

-- ============================================
-- DADOS DE TESTE (OPCIONAL)
-- ============================================

-- Inserir dados de teste para o usuário logado
-- Substitua 'SEU_USER_ID' pelo ID real do seu usuário

/*
insert into public.user_gamification (user_id, total_xp, total_km, current_streak, longest_streak)
values 
  (auth.uid(), 1500, 25.50, 5, 10)
on conflict (user_id) 
do update set 
  total_xp = excluded.total_xp,
  total_km = excluded.total_km,
  current_streak = excluded.current_streak,
  longest_streak = excluded.longest_streak;
*/

-- ============================================
-- CONCLUSÃO
-- ============================================

-- Execute todo este script no Supabase SQL Editor
-- Depois teste o app e o ranking deve funcionar!
