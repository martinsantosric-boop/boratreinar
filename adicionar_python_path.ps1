# Script para adicionar Python ao PATH
# Execute como Administrador

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  ADICIONAR PYTHON AO PATH" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Procurar instalações do Python
$possiveisCaminhos = @(
    "$env:LOCALAPPDATA\Programs\Python\Python314",
    "$env:LOCALAPPDATA\Programs\Python\Python313",
    "$env:LOCALAPPDATA\Programs\Python\Python312",
    "C:\Python314",
    "C:\Python313",
    "C:\Python312",
    "$env:USERPROFILE\AppData\Local\Programs\Python\Python314",
    "$env:USERPROFILE\AppData\Local\Programs\Python\Python313"
)

$pythonPath = $null

Write-Host "Procurando Python instalado..." -ForegroundColor Yellow

foreach ($caminho in $possiveisCaminhos) {
    if (Test-Path "$caminho\python.exe") {
        $pythonPath = $caminho
        Write-Host "✓ Encontrado: $pythonPath" -ForegroundColor Green
        break
    }
}

if ($pythonPath -eq $null) {
    Write-Host "✗ Python não encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Verifique onde o Python foi instalado:" -ForegroundColor Yellow
    Write-Host "1. Abra o menu Iniciar"
    Write-Host "2. Digite 'Python' e clique com botão direito"
    Write-Host "3. Abrir local do arquivo"
    Write-Host "4. Veja o caminho completo"
    Write-Host ""
    Read-Host "Pressione Enter para sair"
    exit
}

$scriptsPath = "$pythonPath\Scripts"

Write-Host ""
Write-Host "Adicionando ao PATH do usuário..." -ForegroundColor Yellow

# Obter PATH atual
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")

# Verificar se já está no PATH
if ($currentPath -like "*$pythonPath*") {
    Write-Host "✓ Python já está no PATH!" -ForegroundColor Green
} else {
    # Adicionar Python ao PATH
    $newPath = $currentPath + ";$pythonPath;$scriptsPath"
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "✓ Python adicionado ao PATH!" -ForegroundColor Green
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "  CONCLUÍDO!" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "IMPORTANTE:" -ForegroundColor Yellow
Write-Host "1. FECHE este PowerShell" -ForegroundColor Yellow
Write-Host "2. Abra um NOVO PowerShell" -ForegroundColor Yellow
Write-Host "3. Execute: python --version" -ForegroundColor Yellow
Write-Host ""
Read-Host "Pressione Enter para sair"
