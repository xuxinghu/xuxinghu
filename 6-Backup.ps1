<#
.SYNOPSIS
  Backup a folder to a timestamped ZIP file (inspired by sync/backup scripts).
.EXAMPLE
  powershell -File 6-Backup.ps1 -Source C:\Users\Administrator\Documents\work
  powershell -File 6-Backup.ps1 -Source .\work -Dest D:\backups
#>
param(
    [Parameter(Mandatory = $true)][string]$Source,
    [string]$Dest = "C:\Users\Administrator\Desktop\backups"
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Source)) {
    Write-Output "ERROR: Source not found: $Source"
    exit 1
}

if (-not (Test-Path $Dest)) {
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
}

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$srcName = Split-Path -Leaf (Resolve-Path $Source)
$zipName = "{0}_{1}.zip" -f $srcName, $stamp
$zipPath = Join-Path $Dest $zipName

Write-Output "==> Backing up"
Write-Output ("    Source: {0}" -f (Resolve-Path $Source))
Write-Output ("    Target: {0}" -f $zipPath)

if (Test-Path $zipPath) {
    Write-Output "ERROR: zip already exists, pick another time."
    exit 1
}

Compress-Archive -Path (Join-Path (Resolve-Path $Source) "*") -DestinationPath $zipPath

$sizeMB = [math]::Round((Get-Item $zipPath).Length / 1MB, 1)
Write-Output ("`nDone. Backup created: {0} ({1} MB)" -f $zipPath, $sizeMB)
