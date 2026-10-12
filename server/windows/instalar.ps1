# Instala el schema de Project: New Order y Helix en tu Garry's Mod (Windows).
# Uso: doble clic en instalar.bat, o: powershell -ExecutionPolicy Bypass -File instalar.ps1 [-GmodPath "D:\...\GarrysMod"]
param([string]$GmodPath)

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

function Find-GarrysMod {
	$steam = (Get-ItemProperty 'HKCU:\Software\Valve\Steam' -ErrorAction SilentlyContinue).SteamPath
	if (-not $steam) { return $null }

	$libraries = @($steam)
	$vdf = Join-Path $steam 'steamapps\libraryfolders.vdf'

	if (Test-Path $vdf) {
		foreach ($match in [regex]::Matches((Get-Content $vdf -Raw), '"path"\s+"([^"]+)"')) {
			$libraries += $match.Groups[1].Value -replace '\\\\', '\'
		}
	}

	foreach ($library in $libraries) {
		$candidate = Join-Path $library 'steamapps\common\GarrysMod'
		if (Test-Path (Join-Path $candidate 'garrysmod')) { return $candidate }
	}
}

if (-not $GmodPath) { $GmodPath = Find-GarrysMod }

if (-not $GmodPath -or -not (Test-Path (Join-Path $GmodPath 'garrysmod'))) {
	Write-Host 'No encuentro Garry''s Mod. Pasa la ruta: instalar.bat "D:\SteamLibrary\steamapps\common\GarrysMod"' -ForegroundColor Red
	exit 1
}

$gamemodes = Join-Path $GmodPath 'garrysmod\gamemodes'
Write-Host "Garry's Mod: $GmodPath"

# Copias mal colocadas de intentos anteriores.
foreach ($wrong in 'project-new-order', 'helix-master', 'helix-main') {
	if (Test-Path (Join-Path $gamemodes $wrong)) {
		Write-Host "AVISO: sobra la carpeta gamemodes\$wrong. Bórrala." -ForegroundColor Yellow
	}
}

# Helix
$helix = Join-Path $gamemodes 'helix'

if (Test-Path (Join-Path $helix 'helix.txt')) {
	Write-Host 'Helix ya está instalado.'
} elseif (Test-Path $helix) {
	Write-Host "gamemodes\helix existe pero no contiene helix.txt. Bórrala y vuelve a ejecutar." -ForegroundColor Red
	exit 1
} else {
	Write-Host 'Descargando Helix...'
	$zip = Join-Path $env:TEMP 'helix.zip'
	$extract = Join-Path $env:TEMP 'helix-extract'

	Invoke-WebRequest 'https://github.com/NebulousCloud/helix/archive/refs/heads/master.zip' -OutFile $zip
	if (Test-Path $extract) { Remove-Item $extract -Recurse -Force }
	Expand-Archive $zip $extract
	Move-Item (Get-ChildItem $extract -Directory | Select-Object -First 1).FullName $helix
	Remove-Item $zip, $extract -Recurse -Force
}

# Schema
$source = Join-Path $repo 'gamemodes\neworder'
$dest = Join-Path $gamemodes 'neworder'

if (-not (Test-Path (Join-Path $source 'neworder.txt'))) {
	Write-Host "No encuentro $source\neworder.txt. Ejecuta el script desde el repositorio." -ForegroundColor Red
	exit 1
}

if (Test-Path $dest) { Remove-Item $dest -Recurse -Force }
Copy-Item $source $dest -Recurse

Write-Host ''
Write-Host 'Listo. CIERRA Garry''s Mod del todo y vuelve a abrirlo; el modo aparecerá como "Project: New Order".' -ForegroundColor Green
