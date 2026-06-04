# Script para copiar imagens do Bolt para pendrive
# Execute: .\copiar-para-pendrive.ps1

Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "📦 COPIAR IMAGENS DO BOLT PARA PENDRIVE" -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""

# Verificar se pastas de origem existem
$expressionsPath = "assets\bolt\expressions"
$leaguesPath = "assets\bolt\leagues"

if (-not (Test-Path $expressionsPath)) {
    Write-Host "❌ Erro: Pasta $expressionsPath não encontrada!" -ForegroundColor Red
    Write-Host "   Certifique-se de estar na pasta do projeto." -ForegroundColor Yellow
    exit 1
}

if (-not (Test-Path $leaguesPath)) {
    Write-Host "❌ Erro: Pasta $leaguesPath não encontrada!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Pastas encontradas!" -ForegroundColor Green
Write-Host ""

# Contar arquivos
$expressionsCount = (Get-ChildItem -Path $expressionsPath -Filter "*.png").Count
$leaguesCount = (Get-ChildItem -Path $leaguesPath -Filter "*.png").Count

Write-Host "📊 Arquivos encontrados:" -ForegroundColor Yellow
Write-Host "   Expressões: $expressionsCount PNGs" -ForegroundColor White
Write-Host "   Ligas: $leaguesCount PNGs" -ForegroundColor White
Write-Host ""

# Listar letras de drives disponíveis
Write-Host "💾 Drives disponíveis:" -ForegroundColor Yellow
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Name -match '^[D-Z]$' } | ForEach-Object {
    $drive = $_.Name
    $used = [math]::Round($_.Used / 1GB, 2)
    $free = [math]::Round($_.Free / 1GB, 2)
    Write-Host "   $drive`: - $($_.Description) - Livre: ${free}GB" -ForegroundColor White
}
Write-Host ""

# Solicitar letra do drive
Write-Host "Digite a letra do pendrive (ex: E, F, G):" -ForegroundColor Yellow
$driveLetter = Read-Host "Letra"

# Validar entrada
if ($driveLetter -notmatch '^[A-Z]$') {
    Write-Host ""
    Write-Host "❌ Erro: Digite apenas uma letra (A-Z)" -ForegroundColor Red
    exit 1
}

$destinationRoot = "${driveLetter}:\boratreinar-backup"
$destinationExpressions = "$destinationRoot\expressions"
$destinationLeagues = "$destinationRoot\leagues"

Write-Host ""
Write-Host "📁 Destino: $destinationRoot" -ForegroundColor Cyan
Write-Host ""

# Perguntar se quer continuar
Write-Host "Deseja continuar com a cópia? (S/N):" -ForegroundColor Yellow
$confirm = Read-Host

if ($confirm -ne 'S' -and $confirm -ne 's') {
    Write-Host ""
    Write-Host "❌ Operação cancelada." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "🚀 INICIANDO CÓPIA..." -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""

# Criar pasta de destino
try {
    if (-not (Test-Path $destinationRoot)) {
        New-Item -ItemType Directory -Path $destinationRoot -Force | Out-Null
        Write-Host "✅ Pasta criada: $destinationRoot" -ForegroundColor Green
    }

    # Copiar expressions
    Write-Host "📂 Copiando expressions..." -ForegroundColor Yellow
    Copy-Item -Path $expressionsPath -Destination $destinationRoot -Recurse -Force
    Write-Host "✅ Copiado: expressions ($expressionsCount arquivos)" -ForegroundColor Green

    # Copiar leagues
    Write-Host "📂 Copiando leagues..." -ForegroundColor Yellow
    Copy-Item -Path $leaguesPath -Destination $destinationRoot -Recurse -Force
    Write-Host "✅ Copiado: leagues ($leaguesCount arquivos)" -ForegroundColor Green

    # Copiar documentação importante
    Write-Host "📂 Copiando documentação..." -ForegroundColor Yellow
    $docs = @(
        "RELATORIO-COMPLETO-PARA-OUTRO-PC.md",
        "LISTA-IMAGENS-PARA-COPIAR.txt",
        "LEIA-ME-PRIMEIRO.md",
        "COMANDOS-RAPIDOS.md",
        "prompt-ia-simples.txt"
    )
    
    $docsCopied = 0
    foreach ($doc in $docs) {
        if (Test-Path $doc) {
            Copy-Item -Path $doc -Destination $destinationRoot -Force
            $docsCopied++
        }
    }
    Write-Host "✅ Copiado: $docsCopied documentos" -ForegroundColor Green

    Write-Host ""
    Write-Host "===========================================================" -ForegroundColor Cyan
    Write-Host "✅ CÓPIA CONCLUÍDA COM SUCESSO!" -ForegroundColor Green
    Write-Host "===========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📁 Arquivos copiados para:" -ForegroundColor Yellow
    Write-Host "   $destinationRoot" -ForegroundColor White
    Write-Host ""
    Write-Host "📋 Conteúdo:" -ForegroundColor Yellow
    Write-Host "   ├─ expressions/ ($expressionsCount PNGs)" -ForegroundColor White
    Write-Host "   ├─ leagues/ ($leaguesCount PNGs)" -ForegroundColor White
    Write-Host "   └─ documentação ($docsCopied arquivos .md/.txt)" -ForegroundColor White
    Write-Host ""
    Write-Host "===========================================================" -ForegroundColor Cyan
    Write-Host "📌 NO OUTRO COMPUTADOR:" -ForegroundColor Yellow
    Write-Host "===========================================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. Copie o projeto boratreinar inteiro, OU:" -ForegroundColor White
    Write-Host ""
    Write-Host "2. Cole as pastas de imagens em:" -ForegroundColor White
    Write-Host "   D:\Projetos\boratreinar\assets\bolt\" -ForegroundColor Gray
    Write-Host ""
    Write-Host "   Estrutura final:" -ForegroundColor White
    Write-Host "   assets\" -ForegroundColor Gray
    Write-Host "   └─ bolt\" -ForegroundColor Gray
    Write-Host "      ├─ expressions\" -ForegroundColor Gray
    Write-Host "      └─ leagues\" -ForegroundColor Gray
    Write-Host ""
    Write-Host "3. Execute:" -ForegroundColor White
    Write-Host "   flutter pub get" -ForegroundColor Gray
    Write-Host "   flutter build web --release" -ForegroundColor Gray
    Write-Host "   firebase deploy --only hosting" -ForegroundColor Gray
    Write-Host ""
    Write-Host "===========================================================" -ForegroundColor Cyan
    Write-Host "📖 Leia: RELATORIO-COMPLETO-PARA-OUTRO-PC.md" -ForegroundColor Yellow
    Write-Host "===========================================================" -ForegroundColor Cyan
    Write-Host ""

    # Abrir pasta no Explorer
    Write-Host "Deseja abrir a pasta no Explorer? (S/N):" -ForegroundColor Yellow
    $openExplorer = Read-Host
    
    if ($openExplorer -eq 'S' -or $openExplorer -eq 's') {
        Start-Process explorer.exe $destinationRoot
    }

} catch {
    Write-Host ""
    Write-Host "❌ ERRO durante a cópia:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Possíveis causas:" -ForegroundColor Yellow
    Write-Host "- Pendrive não tem espaço suficiente" -ForegroundColor Gray
    Write-Host "- Pendrive está protegido contra gravação" -ForegroundColor Gray
    Write-Host "- Letra de drive incorreta" -ForegroundColor Gray
    Write-Host ""
    exit 1
}
