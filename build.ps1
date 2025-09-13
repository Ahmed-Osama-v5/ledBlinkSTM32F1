# STM32F103 LED Blink Project Build Script for Windows PowerShell
# This script builds the project using CMake and ARM GCC toolchain

Write-Host "=== STM32F103 LED Blink Project Build Script ===" -ForegroundColor Green

# Check if HAL library exists
if (-not (Test-Path "hal\Inc")) {
    Write-Host "Error: STM32 HAL library not found!" -ForegroundColor Red
    Write-Host "Please run setup_hal.bat first to download the HAL library."
    Write-Host ""
    Write-Host "Run: .\setup_hal.bat"
    Write-Host "Then: .\build.ps1"
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if ARM GCC toolchain is installed
if (-not (Get-Command "arm-none-eabi-gcc" -ErrorAction SilentlyContinue)) {
    Write-Host "Error: ARM GCC toolchain not found!" -ForegroundColor Red
    Write-Host "Please install arm-none-eabi-gcc toolchain:"
    Write-Host "  Download from: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm"
    Write-Host "  Or use chocolatey: choco install gcc-arm-embedded"
    Write-Host "  Or use scoop: scoop install gcc-arm-none-eabi"
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if CMake is installed
if (-not (Get-Command "cmake" -ErrorAction SilentlyContinue)) {
    Write-Host "Error: CMake not found!" -ForegroundColor Red
    Write-Host "Please install CMake:"
    Write-Host "  Download from: https://cmake.org/download/"
    Write-Host "  Or use chocolatey: choco install cmake"
    Write-Host "  Or use scoop: scoop install cmake"
    Read-Host "Press Enter to exit"
    exit 1
}

# Create build directory if it doesn't exist
if (-not (Test-Path "build")) {
    New-Item -ItemType Directory -Path "build" | Out-Null
}

# Navigate to build directory
Set-Location "build"

try {
    Write-Host "Configuring project with CMake..." -ForegroundColor Yellow
    & cmake -G "MinGW Makefiles" ..
    if ($LASTEXITCODE -ne 0) {
        throw "CMake configuration failed!"
    }

    Write-Host "Building project..." -ForegroundColor Yellow
    
    # Try different make commands
    $makeCmd = $null
    if (Get-Command "mingw32-make" -ErrorAction SilentlyContinue) {
        $makeCmd = "mingw32-make"
    } elseif (Get-Command "make" -ErrorAction SilentlyContinue) {
        $makeCmd = "make"
    } else {
        Write-Host "Make utility not found, using cmake --build instead..." -ForegroundColor Yellow
        & cmake --build . --parallel $env:NUMBER_OF_PROCESSORS
        if ($LASTEXITCODE -ne 0) {
            throw "Build failed!"
        }
    }
    
    if ($makeCmd) {
        & $makeCmd -j$env:NUMBER_OF_PROCESSORS
        if ($LASTEXITCODE -ne 0) {
            throw "Build failed!"
        }
    }

    Write-Host ""
    Write-Host "=== Build Complete ===" -ForegroundColor Green
    Write-Host "Generated files:"
    Write-Host "  - stm32f103_led_blink.elf (ELF executable)"
    Write-Host "  - stm32f103_led_blink.hex (Intel HEX format)"
    Write-Host "  - stm32f103_led_blink.bin (Binary format)"
    Write-Host ""
    Write-Host "To flash the firmware:"
    if ($makeCmd) {
        Write-Host "  $makeCmd flash"
    }
    Write-Host "  st-flash write stm32f103_led_blink.bin 0x8000000"
    Write-Host ""
    Write-Host "Build completed successfully!" -ForegroundColor Green
}
catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Set-Location ..
    Read-Host "Press Enter to exit"
    exit 1
}

Set-Location ..
Read-Host "Press Enter to exit"