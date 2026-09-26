<#
.SYNOPSIS
  Safe batch rename (inspired by file management scripts).
  Dry-run by default: shows what WOULD be renamed. Add -Apply to actually rename.
.EXAMPLE
  powershell -File 2-BatchRename.ps1 -Path .\photos -Find "IMG_" -Replace "2026_"
  powershell -File 2-BatchRename.ps1 -Path .\photos -Find "IMG_" -Replace "2026_" -Apply
#>
param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Find,
    [Parameter(Mandatory = $true)][string]$Replace,
    [switch]$Apply
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Path)) {
    Write-Output "ERROR: Path not found: $Path"
    exit 1
}

$files = Get-ChildItem -Path $Path -File | Where-Object { $_.Name.Contains($Find) }

if ($files.Count -eq 0) {
    Write-Output "No files contain '$Find' in folder $Path"
    exit 0
}

$plan = @()
foreach ($f in $files) {
    $newName = $f.Name.Replace($Find, $Replace)
    $plan += [pscustomobject]@{ Old = $f.Name; New = $newName; Full = $f.FullName }
}

Write-Output ("==> {0} file(s) matched. Preview:" -f $plan.Count)
$plan | ForEach-Object { Write-Output ("  {0}  ->  {1}" -f $_.Old, $_.New) }

if (-not $Apply) {
    Write-Output "`nDRY RUN only. Nothing renamed. Add -Apply to execute."
} else {
    $ok = 0; $fail = 0
    foreach ($p in $plan) {
        try {
            Rename-Item -LiteralPath $p.Full -NewName $p.New -ErrorAction Stop
            $ok++
        } catch {
            Write-Output "  FAILED: $($p.Old) - $($_.Exception.Message)"
            $fail++
        }
    }
    Write-Output ("`nDone. Renamed: {0}, Failed: {1}" -f $ok, $fail)
}
