<#
.SYNOPSIS
  System overview: CPU, memory, disk, top processes (inspired by btop/monitoring scripts).
#>
$ErrorActionPreference = "SilentlyContinue"

Write-Output "======== SYSTEM OVERVIEW ========"
Write-Output ("Computer : {0}" -f $env:COMPUTERNAME)
Write-Output ("User     : {0}" -f $env:USERNAME)
Write-Output ("Time     : {0}" -f (Get-Date))

# --- CPU ---
$cpu = Get-CimInstance Win32_Processor | Select-Object -First 1
Write-Output "`n--- CPU ---"
Write-Output ("Model    : {0}" -f $cpu.Name.Trim())
Write-Output ("Cores    : {0} physical / {1} logical" -f $cpu.NumberOfCores, $cpu.NumberOfLogicalProcessors)
Write-Output ("Load     : {0}%" -f $cpu.LoadPercentage)

# --- Memory ---
$os = Get-CimInstance Win32_OperatingSystem
$totalGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeGB  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)
$usedGB  = [math]::Round($totalGB - $freeGB, 2)
$pct     = [math]::Round(($usedGB / $totalGB) * 100, 1)
Write-Output "`n--- Memory ---"
Write-Output ("Total {0} GB | Used {1} GB ({2}%) | Free {3} GB" -f $totalGB, $usedGB, $pct, $freeGB)

# --- Disks ---
Write-Output "`n--- Disks ---"
Get-CimInstance Win32_LogicalDisk -Filter "DriveType=3" | ForEach-Object {
    $tGB = [math]::Round($_.Size / 1GB, 1)
    $fGB = [math]::Round($_.FreeSpace / 1GB, 1)
    $uPct = if ($tGB -gt 0) { [math]::Round((($tGB - $fGB) / $tGB) * 100, 1) } else { 0 }
    Write-Output ("{0} Total {1} GB | Free {2} GB | Used {3}%" -f $_.DeviceID, $tGB, $fGB, $uPct)
}

# --- Top processes by memory ---
Write-Output "`n--- Top 10 processes by memory ---"
Get-Process | Sort-Object WorkingSet64 -Descending |
    Select-Object -First 10 |
    ForEach-Object {
        $mb = [math]::Round($_.WorkingSet64 / 1MB, 0)
        Write-Output ("{0,8} MB  {1}" -f $mb, $_.ProcessName)
    }

Write-Output "`nDone."
