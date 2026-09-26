<#
.SYNOPSIS
  Find duplicate files by size + hash. Report ONLY (nothing deleted).
  Inspired by cleanup/dedup scripts. Results saved to duplicates.csv next to this script.
.EXAMPLE
  powershell -File 4-DuplicateFinder.ps1 -Path C:\Users\Administrator\Downloads
#>
param(
    [Parameter(Mandatory = $true)][string]$Path,
    [int]$MinSizeKB = 100   # only consider files >= this size
)

$ErrorActionPreference = "SilentlyContinue"

if (-not (Test-Path $Path)) {
    Write-Output "ERROR: Path not found: $Path"
    exit 1
}

Write-Output ("==> Grouping files by size (min {0} KB) ..." -f $MinSizeKB)
$candidates = Get-ChildItem -Path $Path -Recurse -File |
    Where-Object { $_.Length -ge ($MinSizeKB * 1KB) } |
    Group-Object Length |
    Where-Object { $_.Count -gt 1 }

if ($candidates.Count -eq 0) {
    Write-Output "No duplicate-size candidates found."
    exit 0
}

Write-Output ("==> Hashing {0} size-groups (this may take a while) ..." -f $candidates.Count)
$hashGroups = @{}
foreach ($group in $candidates) {
    foreach ($f in $group.Group) {
        $h = Get-FileHash -LiteralPath $f.FullName -Algorithm MD5
        $key = "{0}_{1}" -f $f.Length, $h.Hash
        if (-not $hashGroups.ContainsKey($key)) { $hashGroups[$key] = @() }
        $hashGroups[$key] += $f.FullName
    }
}

$dups = $hashGroups.Values | Where-Object { $_.Count -gt 1 }

if ($dups.Count -eq 0) {
    Write-Output "No true duplicates found."
    exit 0
}

$report = @()
$i = 0
foreach ($set in $dups) {
    $i++
    $set | ForEach-Object {
        $report += [pscustomobject]@{ Group = $i; File = $_ }
    }
}

$csv = Join-Path $PSScriptRoot "duplicates.csv"
$report | Export-Csv -Path $csv -NoTypeInformation -Encoding UTF8

$wastedMB = 0
foreach ($set in $dups) {
    $wastedMB += (Get-Item -LiteralPath $set[0]).Length * ($set.Count - 1)
}
$wastedMB = [math]::Round($wastedMB / 1MB, 1)
Write-Output ("`nFound {0} duplicate groups (approx {1} MB wasted). Report saved to:" -f $dups.Count, $wastedMB)
Write-Output $csv
Write-Output "`nNOTE: This script only REPORTS. Nothing was deleted."
