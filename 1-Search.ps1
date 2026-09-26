<#
.SYNOPSIS
  Fast file-name and content search (inspired by fd + ripgrep).
.EXAMPLE
  powershell -File 1-Search.ps1 -Name "*.jpg" -Path C:\Users\Administrator\Pictures
  powershell -File 1-Search.ps1 -Content "TODO" -Path .\my-project
#>
param(
    [string]$Name = "",      # file name wildcard, e.g. *.log
    [string]$Content = "",   # text to search inside files
    [string]$Path = ".",     # directory to search
    [int]$Limit = 100        # max results
)

$ErrorActionPreference = "SilentlyContinue"

if ($Name -ne "") {
    Write-Output "==> Searching files matching '$Name' under $Path ..."
    Get-ChildItem -Path $Path -Recurse -Filter $Name -File |
        Select-Object -First $Limit |
        ForEach-Object {
            $sizeKB = [math]::Round($_.Length / 1KB, 1)
            Write-Output ("{0,10} KB  {1}" -f $sizeKB, $_.FullName)
        }
}

if ($Content -ne "") {
    Write-Output "==> Searching content '$Content' under $Path ..."
    Get-ChildItem -Path $Path -Recurse -File -Include *.txt,*.log,*.md,*.csv,*.json,*.xml,*.ini,*.cfg,*.ps1,*.bat,*.js,*.py,*.html,*.css |
        Select-String -Pattern $Content -SimpleMatch |
        Select-Object -First $Limit |
        ForEach-Object {
            Write-Output ("{0}:{1}: {2}" -f $_.Path, $_.LineNumber, $_.Line.Trim())
        }
}

if ($Name -eq "" -and $Content -eq "") {
    Write-Output "Usage examples:"
    Write-Output '  powershell -File 1-Search.ps1 -Name "*.jpg" -Path C:\Users\Administrator\Pictures'
    Write-Output '  powershell -File 1-Search.ps1 -Content "error" -Path .\logs'
}
