@echo off
echo Running FileCollector for C# Project...

REM Check if FileCollector.exe exists
if not exist "FileCollector.exe" (
    echo Error: FileCollector.exe not found in the current directory.
    echo Please place FileCollector.exe in the same directory as this batch file.
    pause
    exit /b 1
)

REM Get current directory
set "CURRENT_DIR=%CD%"

REM Check if .sln file exists in current directory
set SLN_EXISTS=0
for %%f in (*.sln) do (
    set SLN_EXISTS=1
)

if %SLN_EXISTS%==0 (
    echo Warning: No .sln file found in current directory.
    echo Make sure you're running this from your C# project root.
    echo.
    set /p CONTINUE=Continue anyway? (Y/N): 
    if /i "%CONTINUE%"=="N" exit /b 0
)

echo.
echo Choose collection mode:
echo 1. Full collection (all files)
echo 2. AI-optimized (recommended: C# only, optimized collections and JSON)
echo 3. Custom configuration
echo.
set /p MODE=Enter option (1-3): 

if "%MODE%"=="1" (
    FileCollector.exe "%CURRENT_DIR%" "%CURRENT_DIR%\project_summary.md"
) else if "%MODE%"=="2" (
    FileCollector.exe --csharp-only --optimize --max-size 500 "%CURRENT_DIR%" "%CURRENT_DIR%\project_summary.md"
) else if "%MODE%"=="3" (
    echo.
    echo Custom Configuration:
    echo.
    
    set /p MAX_SIZE=Max file size in KB (default: 1024): 
    if "%MAX_SIZE%"=="" set MAX_SIZE=1024
    
    set EXCLUDE_DIRS=
    :exclude_loop
    set /p EXCLUDE_DIR=Enter directory to exclude (or press Enter to continue): 
    if not "%EXCLUDE_DIR%"=="" (
        set EXCLUDE_DIRS=!EXCLUDE_DIRS! --exclude-dir "%EXCLUDE_DIR%"
        goto exclude_loop
    )
    
    set /p CSHARP_ONLY=Include only C# files? (Y/N, default: Y): 
    if /i "%CSHARP_ONLY%"=="Y" (
        set CSHARP_FLAG=--csharp-only
    ) else (
        set CSHARP_FLAG=
    )
    
    set /p OPTIMIZE=Optimize arrays and collections? (Y/N, default: Y): 
    if /i "%OPTIMIZE%"=="Y" (
        set OPTIMIZE_FLAG=--optimize
    ) else if /i "%OPTIMIZE%"=="N" (
        set OPTIMIZE_FLAG=--no-optimize
    ) else (
        set OPTIMIZE_FLAG=--optimize
    )
    
    FileCollector.exe %CSHARP_FLAG% --max-size %MAX_SIZE% %EXCLUDE_DIRS% %OPTIMIZE_FLAG% "%CURRENT_DIR%" "%CURRENT_DIR%\project_summary.md"
) else (
    echo Invalid option selected.
    exit /b 1
)

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Error running FileCollector. Please check the output above.
) else (
    echo.
    echo Collection complete! Project summary created at:
    echo %CURRENT_DIR%\project_summary.md
)

echo.
pause