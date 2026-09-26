<#
.SYNOPSIS
  Scan junk candidates: temp folders, Recycle Bin size, large files.
  REPORT ONLY - nothing is deleted. Inspired by Bloatynosy/cleanup scripts.
.EXAMPLE
  powershell -File 5-JunkScan.ps1
  powershell -File 5-JunkScan.ps1 -LargePath C:\Users\Administrator\Downloads -MinMB 200
#>
param(
    [string]$LargePath = "C:\Users\Administrator",
    [int]$MinMB = 500          # threshold for "large file"
)

$ErrorActionPreference = "SilentlyContinue"

Write-Output "======== JUNK SCAN (report only) ========"

# --- Temp folders ---
Write-Output "`n--- Temp folders ---"
$temps = @($env:TEMP, "C:\Windows\Temp")
foreach ($t in $temps) {
    if (Test-Path $t) {
        $size = (Get-ChildItem $t -Recurse -File | Measure-Object Length -Sum).Sum
        $mb = [math]::Round($size / 1MB, 1)
        Write-Output ("{0}  :  {1} MB" -f $t, $mb)
    }
}

# --- Recycle Bin ---
Write-Output "`n--- Recycle Bin ---"
$shell = New-Object -ComObject Shell.Application
$rb = $shell.Namespace(0xA)
$rbSize = 0
if ($rb) {
    foreach ($item in $rb.Items()) {
        $f = $rb.GetDetailsOf($item, 2)   # Size column (display string)
        $rbSize++ 
    }
}
Write-Output ("Items in Recycle Bin: {0}" -f $rbSize)

# --- Large files ---
Write-Output ("`n--- Files larger than {0} MB under {1} (top 20) ---" -f $MinMB, $LargePath)
Get-ChildItem $LargePath -Recurse -File |
    Where-Object { $_.Length -ge ($MinMB * 1MB) } |
    Sort-Object Length -Descending |
    Select-Object -First 20 |
    ForEach-Object {
        $mb = [math]::Round($_.Length / 1MB, 0)
        Write-Output ("{0,8} MB  {1}" -f $mb, $_.FullName)
    }

Write-Output "`nNOTE: Nothing was deleted. Review the list, then decide manually."
Write-Output "Safe to clean yourself: %TEMP% contents older than 7 days, Recycle Bin."
