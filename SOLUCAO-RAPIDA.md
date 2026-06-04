# ⚡ Solução Rápida - Erro 404 Leaderboard

## 🎯 Problema
Erro 404 ao acessar ranking: `leaderboard` não existe.

## ✅ Solução Aplicada (Temporária)

Adicionei tratamento de erro no código para o app não crashar:

```dart
// leaderboard_service.dart agora retorna lista vazia se der erro
try {
  // carrega ranking
} catch (e) {
  return []; // lista vazia
}
```

Isso faz o app funcionar mesmo sem o banco configurado.

## 🔧 Para Funcionar 100% (Execute no Supabase)

### Opção 1 - Solução Completa (Recomendada)

1. Abra: https://supabase.com/dashboard
2. Vá em **SQL Editor**
3. Execute o arquivo: `EXECUTAR_NO_SUPABASE.sql`
4. Pronto! Ranking funcionará com dados reais

### Opção 2 - Continuar Sem Ranking

O app funciona normalmente, só o ranking fica vazio.
Você pode implementar o ranking depois.

## 🚀 Deploy Agora

```powershell
flutter build web --release
firebase deploy --only hosting
```

Ou apenas:
```powershell
Ctrl + Shift + R no navegador
```

## 📋 Checklist

- [x] Código corrigido (não crasha mais)
- [ ] SQL executado no Supabase (para ranking funcionar)
- [ ] Deploy realizado
- [ ] App testado

## 💡 Dica

Execute o SQL do `EXECUTAR_NO_SUPABASE.sql` quando tiver tempo.
Por enquanto, o app funciona sem o ranking!
