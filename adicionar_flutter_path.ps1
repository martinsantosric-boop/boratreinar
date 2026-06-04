# Script para adicionar Flutter ao PATH do Windows
# Execute: .\adicionar_flutter_path.ps1

Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "🔧 ADICIONAR FLUTTER AO PATH" -ForegroundColor Cyan
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""

# Locais comuns onde o Flutter pode estar instalado
$possiblePaths = @(
    "C:\flutter\bin",
    "C:\src\flutter\bin",
    "D:\flutter\bin",
    "$env:USERPROFILE\flutter\bin",
    "$env:LOCALAPPDATA\flutter\bin"
)

Write-Host "🔍 Procurando instalação do Flutter..." -ForegroundColor Yellow
Write-Host ""

$flutterPath = $null

# Procurar Flutter nos locais comuns
foreach ($path in $possiblePaths) {
    if (Test-Path $path) {
        $flutterExe = Join-Path $path "flutter.bat"
        if (Test-Path $flutterExe) {
            Write-Host "✅ Flutter encontrado em: $path" -ForegroundColor Green
            $flutterPath = $path
            break
        }
    }
}

if (-not $flutterPath) {
    Write-Host "❌ Flutter não encontrado nos locais comuns" -ForegroundColor Red
    Write-Host ""
    Write-Host "Por favor, informe o caminho completo da pasta 'bin' do Flutter:" -ForegroundColor Yellow
    Write-Host "Exemplo: C:\flutter\bin" -ForegroundColor Gray
    Write-Host ""
    $flutterPath = Read-Host "Caminho"
    
    if (-not (Test-Path $flutterPath)) {
        Write-Host ""
        Write-Host "❌ Caminho inválido: $flutterPath" -ForegroundColor Red
        Write-Host ""
        Write-Host "ALTERNATIVA: Instalar Flutter manualmente" -ForegroundColor Yellow
        Write-Host "1. Baixe: https://docs.flutter.dev/get-started/install/windows" -ForegroundColor Gray
        Write-Host "2. Extraia para C:\flutter" -ForegroundColor Gray
        Write-Host "3. Execute este script novamente" -ForegroundColor Gray
        exit 1
    }
}

Write-Host ""
Write-Host "🔧 Adicionando ao PATH do usuário..." -ForegroundColor Yellow

# Obter PATH atual do usuário
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")

# Verificar se já está no PATH
if ($userPath -like "*$flutterPath*") {
    Write-Host "✅ Flutter já está no PATH!" -ForegroundColor Green
} else {
    # Adicionar ao PATH
    $newPath = "$userPath;$flutterPath"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "✅ Flutter adicionado ao PATH com sucesso!" -ForegroundColor Green
}

# Atualizar PATH da sessão atual
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

Write-Host ""
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host "✅ CONCLUÍDO!" -ForegroundColor Green
Write-Host "===========================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "📋 Próximos passos:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Verificar instalação:" -ForegroundColor White
Write-Host "   flutter --version" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Atualizar dependências:" -ForegroundColor White
Write-Host "   flutter pub get" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Build para web:" -ForegroundColor White
Write-Host "   flutter build web --release" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Deploy:" -ForegroundColor White
Write-Host "   firebase deploy --only hosting" -ForegroundColor Gray
Write-Host ""
Write-Host "⚠️  IMPORTANTE: Se o comando 'flutter' ainda não funcionar," -ForegroundColor Yellow
Write-Host "   feche e reabra o PowerShell/terminal." -ForegroundColor Yellow
Write-Host ""
