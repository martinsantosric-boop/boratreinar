# 🔧 Como Corrigir Erro 404 - Leaderboard

## 🚨 Problema

Erro ao clicar em "Iniciar" ou acessar Ranking:
```
Failed to load resource: the server responded with a status of 404
nvdrcpzxwrvlmgrsxspl.supabase.co/rest/v1/leaderboard
```

**Causa**: A tabela/view `leaderboard` não existe no Supabase ainda.

---

## ✅ Solução - 3 Passos

### Passo 1: Abrir Supabase SQL Editor

1. Acesse: https://supabase.com/dashboard
2. Selecione seu projeto: **gotreiinar** (ou o nome correto)
3. No menu lateral, clique em: **SQL Editor**
4. Clique em: **New query**

### Passo 2: Executar SQL

1. Abra o arquivo: `EXECUTAR_NO_SUPABASE.sql`
2. Copie **TODO** o conteúdo
3. Cole no SQL Editor do Supabase
4. Clique em: **Run** (ou pressione Ctrl+Enter)

### Passo 3: Verificar

Execute esta query para verificar se foi criado:

```sql
select * from public.leaderboard limit 5;
```

- ✅ Se retornar vazio ou com dados: **SUCESSO!**
- ❌ Se retornar erro: Veja seção de troubleshooting abaixo

---

## 📋 O Que o SQL Cria

1. **Tabela `user_gamification`**
   - Armazena XP, km, streaks, achievements de cada usuário

2. **View `leaderboard`**
   - Ranking calculado automaticamente
   - Ordena por XP e km
   - Calcula liga automaticamente

3. **Políticas RLS**
   - Todos podem ver ranking
   - Usuário só edita próprios dados

4. **Triggers**
   - Atualiza `updated_at` automaticamente
   - Inicializa gamificação ao criar perfil

5. **Índices**
   - Otimiza queries de ranking

---

## 🧪 Testar Após Executar SQL

### 1. Recarregar o App

```powershell
# Limpar cache e rebuild
flutter clean
flutter build web --release
firebase deploy --only hosting
```

### 2. Ou simplesmente:

- Pressione `Ctrl + Shift + R` no navegador (hard refresh)
- Ou abra em aba anônima

### 3. Testar Ranking

1. Faça login no app
2. Clique em **Ranking** na barra inferior
3. Deve mostrar "Ranking indisponível" (vazio) ou seus dados

---

## 🎯 Adicionar Dados de Teste (Opcional)

Se quiser ver o ranking funcionando, adicione dados de teste:

```sql
-- No Supabase SQL Editor, execute:

insert into public.user_gamification (user_id, total_xp, total_km, current_streak, longest_streak)
values 
  (auth.uid(), 1500, 25.50, 5, 10)
on conflict (user_id) 
do update set 
  total_xp = 1500,
  total_km = 25.50,
  current_streak = 5,
  longest_streak = 10;
```

Depois, verifique o ranking:

```sql
select * from public.leaderboard;
```

---

## 🐛 Troubleshooting

### Erro: "relation profiles does not exist"

**Causa**: Tabela `profiles` não existe ainda.

**Solução**: Crie a tabela profiles primeiro:

```sql
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text,
  full_name text,
  avatar_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Public profiles are viewable by everyone"
on public.profiles for select
to authenticated
using (true);

create policy "Users can update own profile"
on public.profiles for update
to authenticated
using (auth.uid() = id)
with check (auth.uid() = id);
```

### Erro: "function set_updated_at does not exist"

**Causa**: Função não foi criada antes do trigger.

**Solução**: Execute a parte 4 do SQL novamente (criar função).

### Erro: "permission denied for view leaderboard"

**Causa**: Permissões não configuradas.

**Solução**: Execute:

```sql
grant select on public.leaderboard to authenticated;
grant select on public.user_gamification to authenticated;
```

### View está vazia mas deveria ter dados

**Verificar se existem dados na tabela:**

```sql
select * from public.user_gamification;
```

Se estiver vazio, insira dados de teste (ver seção acima).

---

## 🔍 Verificações Úteis

### Ver todas as tabelas

```sql
select table_name 
from information_schema.tables 
where table_schema = 'public';
```

### Ver todas as views

```sql
select table_name 
from information_schema.views 
where table_schema = 'public';
```

### Ver políticas RLS

```sql
select * from pg_policies 
where tablename = 'user_gamification';
```

### Ver quantos usuários têm gamificação

```sql
select count(*) from public.user_gamification;
```

---

## 🚀 Resultado Final

Após executar o SQL corretamente:

✅ Erro 404 deve sumir  
✅ Tela de Ranking deve carregar  
✅ Gamificação funcionando  
✅ XP sendo salvo após corridas  

---

## 📝 Notas Importantes

1. **Execute TODO o SQL de uma vez** - não execute linha por linha
2. **Use o SQL Editor do Supabase** - não execute no psql local
3. **Verifique o projeto correto** - gotreiinar ou outro
4. **RLS está ativado** - normal, é segurança
5. **View é calculada automaticamente** - não insira dados nela diretamente

---

## 💡 Dica

Salve o arquivo `EXECUTAR_NO_SUPABASE.sql` em um local seguro. Se precisar recriar o banco em outro projeto Supabase, basta executar ele novamente!

---

**Após executar o SQL, o erro 404 deve sumir e o ranking deve funcionar!** 🎉
