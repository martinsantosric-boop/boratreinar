-- ============================================
-- TESTES PARA VERIFICAR SE RANKING FUNCIONA
-- Execute no Supabase SQL Editor
-- ============================================

-- 1. Verificar se tabela user_gamification existe
-- ============================================
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
  AND table_name = 'user_gamification';

-- Se retornar 1 linha: ✅ Tabela existe
-- Se retornar vazio: ❌ Execute EXECUTAR_NO_SUPABASE.sql novamente


-- 2. Verificar se view leaderboard existe
-- ============================================
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public' 
  AND table_name = 'leaderboard';

-- Se retornar 1 linha: ✅ View existe
-- Se retornar vazio: ❌ Execute parte da view do SQL novamente


-- 3. Ver quantos usuários têm gamificação
-- ============================================
SELECT count(*) as total_usuarios
FROM public.user_gamification;

-- Deve retornar número >= 0


-- 4. Ver dados da tabela user_gamification
-- ============================================
SELECT 
  user_id,
  total_xp,
  total_km,
  current_streak,
  longest_streak,
  created_at
FROM public.user_gamification
LIMIT 10;

-- Se vazio: Normal se ninguém correu ainda


-- 5. Testar a view leaderboard
-- ============================================
SELECT 
  full_name,
  email,
  total_xp,
  total_km,
  league,
  rank
FROM public.leaderboard
LIMIT 10;

-- Se der erro: A view não foi criada corretamente
-- Se retornar vazio: Normal se não há dados ainda
-- Se retornar dados: ✅ Funcionando!


-- 6. Ver seu próprio usuário
-- ============================================
SELECT 
  auth.uid() as meu_user_id,
  p.full_name,
  p.email
FROM public.profiles p
WHERE p.id = auth.uid();

-- Mostra seus dados


-- 7. Ver sua gamificação (se existir)
-- ============================================
SELECT 
  user_id,
  total_xp,
  total_km,
  current_streak,
  longest_streak
FROM public.user_gamification
WHERE user_id = auth.uid();

-- Se vazio: Ainda não há dados (precisa fazer uma corrida)
-- Se retornar dados: ✅ Seus dados de gamificação


-- 8. ADICIONAR DADOS DE TESTE (OPCIONAL)
-- ============================================
-- Execute apenas se quiser testar o ranking com dados fictícios

/*
INSERT INTO public.user_gamification (
  user_id, 
  total_xp, 
  total_km, 
  current_streak, 
  longest_streak
)
VALUES 
  (auth.uid(), 1500, 25.50, 5, 10)
ON CONFLICT (user_id) 
DO UPDATE SET 
  total_xp = EXCLUDED.total_xp,
  total_km = EXCLUDED.total_km,
  current_streak = EXCLUDED.current_streak,
  longest_streak = EXCLUDED.longest_streak;
*/

-- Depois de inserir, teste novamente a view:
-- SELECT * FROM public.leaderboard;


-- 9. Ver todas as tabelas públicas
-- ============================================
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public'
ORDER BY table_name;

-- Deve incluir: user_gamification, profiles, etc.


-- 10. Ver todas as views públicas
-- ============================================
SELECT table_name 
FROM information_schema.views 
WHERE table_schema = 'public'
ORDER BY table_name;

-- Deve incluir: leaderboard


-- ============================================
-- TROUBLESHOOTING
-- ============================================

-- Se a view leaderboard der erro "relation profiles does not exist":
/*
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles viewable by everyone"
ON public.profiles FOR SELECT
TO authenticated
USING (true);
*/

-- Depois recrie a view leaderboard executando a parte da view do EXECUTAR_NO_SUPABASE.sql


-- ============================================
-- RESULTADO ESPERADO
-- ============================================

-- ✅ Tabelas existem
-- ✅ View existe
-- ✅ Políticas RLS configuradas
-- ✅ Pode inserir/atualizar seus dados
-- ✅ Pode ver ranking de todos

-- Agora teste no app:
-- 1. Abra https://gotreiinar.web.app
-- 2. Faça login
-- 3. Vá na aba "Ranking"
-- 4. Deve mostrar ranking (vazio ou com dados)
-- 5. Não deve dar erro 404
