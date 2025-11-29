param(
    [Parameter(Mandatory=$true)]
    [string]$Environment
)

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "   Verificando / Creando base de datos" -ForegroundColor Cyan
Write-Host "   Ambiente: $Environment"
Write-Host "============================================" -ForegroundColor Cyan

# Mapeo de puertos por entorno
$ports = @{
    "develop" = 1438
    "qa"      = 1436
    "staging" = 1437
    "main"    = 1435
}

if (-not $ports.ContainsKey($Environment)) {
    Write-Host "❌ Ambiente no válido." -ForegroundColor Red
    exit 1
}

$port = $ports[$Environment]
$dbName = "gescomph_$Environment"

Write-Host "→ Revisando base: $dbName en localhost:$port"

# PARAMETROS PARA SQLCMD (ODBC 18 en Linux)
$sqlParams = "-C","-Q"

# Verificar si existe
$check = sqlcmd -S "localhost,$port" -U "sa" -P "Admin123!" -C `
    -Q "SET NOCOUNT ON; SELECT name FROM sys.databases WHERE name='$dbName'" `
    -h -1 2>$null

if (-not $check) {
    Write-Host "⚠ No existe. Creando base..."
    
    sqlcmd -S "localhost,$port" -U sa -P "Admin123!" -C `
        -Q "CREATE DATABASE [$dbName]" 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "✔ Base creada correctamente." -ForegroundColor Green
    }
    else {
        Write-Host "❌ Error al crear la base." -ForegroundColor Red
        exit 1
    }
}
else {
    Write-Host "✔ La base ya existe." -ForegroundColor Green
}

Write-Host "============================================"
Write-Host "   Finalizado ensure-databases ($Environment)"
Write-Host "============================================"
