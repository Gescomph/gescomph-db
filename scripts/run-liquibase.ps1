param(
    [Parameter(Mandatory=$true)]
    [string]$Environment
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Ejecutando Liquibase"
Write-Host "   Ambiente: $Environment"
Write-Host "============================================" -ForegroundColor Cyan

$props = "Configuration Files/liquibase-$Environment.properties"

if (-not (Test-Path $props)) {
    Write-Host "❌ No existe archivo: $props" -ForegroundColor Red
    exit 1
}

Write-Host "→ Usando properties: $props"

# Ejecutar liquibase
liquibase --defaultsFile="$props" update

if ($LASTEXITCODE -eq 0) {
    Write-Host "✔ Migración exitosa." -ForegroundColor Green
} else {
    Write-Host "❌ Error ejecutando Liquibase." -ForegroundColor Red
}

Write-Host "============================================"
Write-Host "   Finalizado run-liquibase ($Environment)"
Write-Host "============================================"
