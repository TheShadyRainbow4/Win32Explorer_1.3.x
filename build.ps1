# Win32Explorer Build Script
# Zachary Whiteman - EliteSoftwareTech Co.
# Version: 26.0.3.0
# Support: support@elitesoftwaretech.cc
# Website: win32explorer.elitesoftwaretech.cc

$ErrorActionPreference = "Stop"

function Build-App {
    $currentPath = Get-Location
    $parentPath = Split-Path -Path $currentPath -Parent
    $libsDir = Join-Path $parentPath "libs"
    $boostDir = "C:\local\boost_1_87_0"
    $stlsoftDir = Join-Path $libsDir "stlsoft\STLSoft-1.10-master"
    $pantheiosDir = Join-Path $libsDir "pantheios\Pantheios-master"

    Write-Host "--- Win32Explorer Build Started ---" -ForegroundColor Cyan

    # 1. Download Dependencies if missing
    if (-not (Test-Path $libsDir)) {
        Write-Host "Creating libs directory at $libsDir..."
        New-Item -ItemType Directory -Path $libsDir -Force
    }

    if (-not (Test-Path $boostDir)) {
        Write-Host "Boost not found at $boostDir. Attempting to install via choco..."
        choco install boost-msvc-14.3 -y --limit-output --no-progress
    }

    if (-not (Test-Path $stlsoftDir)) {
        Write-Host "Downloading/Extracting STLSoft..."
        if (-not (Test-Path "$libsDir\stlsoft.zip")) {
            Invoke-WebRequest -Uri "https://github.com/synesissoftware/STLSoft-1.10/archive/refs/heads/master.zip" -OutFile "$libsDir\stlsoft.zip"
        }
        Expand-Archive -Path "$libsDir\stlsoft.zip" -DestinationPath "$libsDir\stlsoft" -Force
    }

    if (-not (Test-Path $pantheiosDir)) {
        Write-Host "Downloading/Extracting Pantheios..."
        if (-not (Test-Path "$libsDir\pantheios.zip")) {
            Invoke-WebRequest -Uri "https://github.com/synesissoftware/Pantheios/archive/refs/heads/master.zip" -OutFile "$libsDir\pantheios.zip"
        }
        Expand-Archive -Path "$libsDir\pantheios.zip" -DestinationPath "$libsDir\pantheios" -Force
    }

    # 2. Setup Environment Variables
    Write-Host "Setting up environment variables..."
    $env:BOOST = $boostDir
    $env:BOOST_LIB = Join-Path $boostDir "lib64-msvc-14.3"
    $env:STLSOFT = $stlsoftDir
    $env:PANTHEIOS = $pantheiosDir

    # 3. Build Pantheios if not already built
    $pantheiosLibDir = Join-Path $pantheiosDir "lib"
    if (-not (Test-Path $pantheiosLibDir)) {
        Write-Host "Building Pantheios..."
        Push-Location $pantheiosDir
        if (-not (Test-Path "build")) { New-Item -ItemType Directory -Path "build" }
        cd build
        
        if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
            Write-Host "CMake not found. Installing via choco..."
            choco install cmake -y
            $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        }
        
        cmake .. -G "Visual Studio 17 2022" -A x64
        cmake --build . --config Release
        Pop-Location
    }

    # 4. Build Win32Explorer
    Write-Host "Building Win32Explorer Solution..."
    $msbuild = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
    if (-not (Test-Path $msbuild)) {
        $msbuildPath = Get-Command msbuild -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Source
        if ($msbuildPath) {
            $msbuild = $msbuildPath
        } else {
             Write-Error "MSBuild.exe not found. Please ensure Visual Studio is installed."
             return
        }
    }

    & $msbuild "Win32Explorer\Win32Explorer.sln" /p:Configuration=Release /p:Platform=x64 /t:Rebuild /m
    
    Write-Host "--- Build Complete! ---" -ForegroundColor Green
    Write-Host "Binary location: Win32Explorer\Win32Explorer\x64\Release\Win32Explorer.exe"
}

Build-App
