# PowerShell script to run FileCollector for C# projects

Write-Host "Running FileCollector for C# Project..." -ForegroundColor Cyan

# Check if FileCollector.exe exists
if (-not (Test-Path "FileCollector.exe")) {
    Write-Host "Error: FileCollector.exe not found in the current directory." -ForegroundColor Red
    Write-Host "Please place FileCollector.exe in the same directory as this script." -ForegroundColor Red
    Read-Host "Press Enter to exit"
    exit 1
}

# Get current directory
$currentDir = Get-Location
$outputPath = Join-Path -Path $currentDir -ChildPath "project_summary.md"

# Check if .sln file exists in current directory
$slnExists = Test-Path -Path "*.sln"

if (-not $slnExists) {
    Write-Host "Warning: No .sln file found in current directory." -ForegroundColor Yellow
    Write-Host "Make sure you're running this from your C# project root." -ForegroundColor Yellow
    Write-Host ""
    $continue = Read-Host "Continue anyway? (Y/N)"
    if ($continue -ne "Y" -and $continue -ne "y") {
        exit 0
    }
}

Write-Host ""
Write-Host "Choose collection mode:" -ForegroundColor Cyan
Write-Host "1. Full collection (all files)"
Write-Host "2. AI-optimized (recommended: C# only, optimized collections and JSON)"
Write-Host "3. Custom configuration"
Write-Host ""
$mode = Read-Host "Enter option (1-3)"

switch ($mode) {
    "1" {
        & .\FileCollector.exe "$currentDir" "$outputPath"
    }
    "2" {
        & .\FileCollector.exe --csharp-only --optimize --max-size 500 "$currentDir" "$outputPath"
    }
    "3" {
        Write-Host ""
        Write-Host "Custom Configuration:" -ForegroundColor Cyan
        Write-Host ""
        
        $maxSize = Read-Host "Max file size in KB (default: 1024)"
        if ([string]::IsNullOrEmpty($maxSize)) { $maxSize = "1024" }
        
        $excludeDirs = @()
        while ($true) {
            $excludeDir = Read-Host "Enter directory to exclude (or press Enter to continue)"
            if ([string]::IsNullOrEmpty($excludeDir)) { break }
            $excludeDirs += "--exclude-dir"
            $excludeDirs += $excludeDir
        }
        
        $csharpOnly = Read-Host "Include only C# files? (Y/N, default: Y)"
        $csharpFlag = if ($csharpOnly -ne "N" -and $csharpOnly -ne "n") { "--csharp-only" } else { "" }
        
        $optimizeContent = Read-Host "Optimize arrays and collections? (Y/N, default: Y)"
        $optimizeFlag = if ($optimizeContent -eq "N" -or $optimizeContent -eq "n") { "--no-optimize" } else { "--optimize" }
        
        $params = @()
        if (-not [string]::IsNullOrEmpty($csharpFlag)) { $params += $csharpFlag }
        $params += "--max-size"
        $params += $maxSize
        $params += $excludeDirs
        $params += $optimizeFlag
        $params += "$currentDir"
        $params += "$outputPath"
        
        & .\FileCollector.exe $params
    }
    default {
        Write-Host "Invalid option selected." -ForegroundColor Red
        exit 1
    }
}

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Error running FileCollector. Please check the output above." -ForegroundColor Red
} else {
    Write-Host ""
    Write-Host "Collection complete! Project summary created at:" -ForegroundColor Green
    Write-Host "$outputPath" -ForegroundColor Green
}

Write-Host ""
Read-Host "Press Enter to exit"