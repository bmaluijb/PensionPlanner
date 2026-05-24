@echo off
:: Checks if a compatible .NET SDK (>= 8) is available locally or on the system.
:: If not, downloads the latest .NET 8 LTS to .dotnet/ in the repo (no admin, no system install).

set DOTNET_MIN_MAJOR=8
set DOTNET_CHANNEL=8.0

:: Check if the local .dotnet folder already has the SDK
if exist "%~dp0.dotnet\dotnet.exe" (
    set DOTNET_ROOT=%~dp0.dotnet
    set PATH=%~dp0.dotnet;%PATH%
    goto :done
)

:: Check if dotnet is already on the system with a sufficient major version (8, 9, 10, ...)
where dotnet >nul 2>&1
if %ERRORLEVEL% equ 0 (
    for /f "tokens=1 delims=." %%a in ('dotnet --version 2^>nul') do (
        if %%a GEQ %DOTNET_MIN_MAJOR% goto :done
    )
)

:: No compatible .NET SDK found — download .NET 8 LTS locally
echo.
echo ============================================
echo   .NET SDK %DOTNET_MIN_MAJOR%+ not found on this machine.
echo   Downloading .NET %DOTNET_CHANNEL% to .dotnet\ folder...
echo   (This only happens once, ~200 MB)
echo ============================================
echo.

:: Download the official dotnet-install script
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -OutFile '%TEMP%\dotnet-install.ps1' -UseBasicParsing"

if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to download the .NET install script. Check your internet connection.
    pause
    exit /b 1
)

:: Install .NET SDK locally (no admin, no system changes)
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "& '%TEMP%\dotnet-install.ps1' -Channel '%DOTNET_CHANNEL%' -InstallDir '%~dp0.dotnet' -NoPath"

if %ERRORLEVEL% neq 0 (
    echo ERROR: Failed to install .NET SDK. Check the errors above.
    pause
    exit /b 1
)

echo.
echo .NET %DOTNET_CHANNEL% SDK installed to .dotnet\ folder.
echo.

set DOTNET_ROOT=%~dp0.dotnet
set PATH=%~dp0.dotnet;%PATH%

:done
:: Suppress telemetry and first-run experience
set DOTNET_CLI_TELEMETRY_OPTOUT=1
set DOTNET_NOLOGO=1
set DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
