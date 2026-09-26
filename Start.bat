@echo off
REM Simple menu launcher (ASCII only to avoid codepage issues)
:menu
cls
echo ==========================================
echo   Runnable Scripts Toolkit
echo ==========================================
echo   1. Search files / content
echo   2. Batch rename (dry-run by default)
echo   3. System info (CPU / RAM / disk)
echo   4. Duplicate file finder (report only)
echo   5. Junk scan (report only)
echo   6. Backup folder to ZIP
echo   0. Exit
echo ==========================================
set /p choice=Select: 

if "%choice%"=="1" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp01-Search.ps1"
if "%choice%"=="2" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp02-BatchRename.ps1" -Path "%USERPROFILE%\Desktop" -Find "old" -Replace "new"
if "%choice%"=="3" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp03-SystemInfo.ps1"
if "%choice%"=="4" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp04-DuplicateFinder.ps1" -Path "%USERPROFILE%\Downloads"
if "%choice%"=="5" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp05-JunkScan.ps1"
if "%choice%"=="6" powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp06-Backup.ps1" -Source "%USERPROFILE%\Documents"
if "%choice%"=="0" exit /b

echo.
pause
goto menu
