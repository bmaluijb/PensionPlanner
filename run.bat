@echo off
:: Change to the directory where this script lives
cd /d "%~dp0"

echo ============================================
echo   NN Pension Planner - Starting...
echo ============================================
echo.

:: Ensure a compatible .NET SDK is available (downloads .NET 8 if needed)
call "%~dp0setup-dotnet.bat"
if %ERRORLEVEL% neq 0 exit /b 1

echo Building the application...
dotnet build PensionPlanner.csproj --nologo -verbosity:quiet
if %ERRORLEVEL% neq 0 (
    echo.
    echo ============================================
    echo   Build FAILED. Check the errors above.
    echo ============================================
    pause
    exit /b 1
)

echo.
echo ============================================
echo   Build succeeded!
echo   Opening browser to http://localhost:5000
echo   Press Ctrl+C to stop the application.
echo ============================================
echo.

:: Open browser after a short delay
start "" http://localhost:5000

:: Run the application
dotnet run --project PensionPlanner.csproj --no-build --urls http://localhost:5000

:: If we get here, the app exited — keep window open so user can see why
echo.
echo Application stopped.
pause
