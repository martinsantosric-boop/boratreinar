# Script para cortar 0.5 segundos do início de um vídeo
# Requer FFmpeg instalado

param(
    [string]$VideoPath = "assets\bolt\expressions\ganhar_xp.mp4",
    [double]$CortarInicio = 0.5
)

# Verifica se FFmpeg está instalado
try {
    $null = ffmpeg -version
    Write-Host "✅ FFmpeg encontrado!" -ForegroundColor Green
} catch {
    Write-Host "❌ FFmpeg não encontrado!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Para instalar FFmpeg:" -ForegroundColor Yellow
    Write-Host "1. Usando Chocolatey: choco install ffmpeg"
    Write-Host "2. Ou baixe em: https://ffmpeg.org/download.html"
    Write-Host ""
    Write-Host "Alternativamente, use um editor online:" -ForegroundColor Cyan
    Write-Host "• https://online-video-cutter.com/"
    Write-Host "• https://www.kapwing.com/tools/trim-video"
    exit 1
}

# Verifica se o vídeo existe
if (-not (Test-Path $VideoPath)) {
    Write-Host "❌ Vídeo não encontrado: $VideoPath" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "🎬 Cortando vídeo..." -ForegroundColor Cyan
Write-Host "Entrada: $VideoPath"
Write-Host "Cortando: $CortarInicio segundos do início"

# Nome do arquivo de saída
$OutputPath = $VideoPath -replace '\.mp4$', '_cortado.mp4'

# Executa o FFmpeg
ffmpeg -ss $CortarInicio -i "$VideoPath" -c copy "$OutputPath" -y

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Vídeo cortado com sucesso!" -ForegroundColor Green
    Write-Host "Saída: $OutputPath"
    Write-Host ""
    Write-Host "Para substituir o original:" -ForegroundColor Yellow
    Write-Host "Move-Item -Force '$OutputPath' '$VideoPath'"
} else {
    Write-Host ""
    Write-Host "❌ Erro ao cortar vídeo" -ForegroundColor Red
}
