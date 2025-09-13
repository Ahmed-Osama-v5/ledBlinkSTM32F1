@echo off
REM STM32F103 LED Blink Project Build Script for Windows
REM This script builds the project using CMake and ARM GCC toolchain

echo === STM32F103 LED Blink Project Build Script ===

REM Check if HAL library exists
if not exist "hal\Inc" (
    echo Error: STM32 HAL library not found!
    echo Please run setup_hal.bat first to download the HAL library.
    echo.
    echo Run: setup_hal.bat
    echo Then: build.bat
    pause
    exit /b 1
)

REM Check if ARM GCC toolchain is installed
where arm-none-eabi-gcc >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: ARM GCC toolchain not found!
    echo Please install arm-none-eabi-gcc toolchain:
    echo   Download from: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm
    echo   Or use chocolatey: choco install gcc-arm-embedded
    echo   Or use scoop: scoop install gcc-arm-none-eabi
    pause
    exit /b 1
)

REM Check if CMake is installed
where cmake >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: CMake not found!
    echo Please install CMake:
    echo   Download from: https://cmake.org/download/
    echo   Or use chocolatey: choco install cmake
    echo   Or use scoop: scoop install cmake
    pause
    exit /b 1
)

REM Check if MinGW Make is available (comes with many toolchains)
where mingw32-make >nul 2>&1
if %errorlevel% neq 0 (
    where make >nul 2>&1
    if %errorlevel% neq 0 (
        echo Error: Make utility not found!
        echo Please install MinGW or ensure make is in your PATH
        echo You can also use: cmake --build . instead of make
        pause
        exit /b 1
    )
    set MAKE_CMD=make
) else (
    set MAKE_CMD=mingw32-make
)

REM Create build directory if it doesn't exist
if not exist "build" (
    mkdir build
)

REM Navigate to build directory
cd build

echo Configuring project with CMake...
cmake -G "MinGW Makefiles" ..
if %errorlevel% neq 0 (
    echo CMake configuration failed!
    pause
    exit /b 1
)

echo Building project...
%MAKE_CMD% -j%NUMBER_OF_PROCESSORS%
if %errorlevel% neq 0 (
    echo Build failed!
    pause
    exit /b 1
)

echo.
echo === Build Complete ===
echo Generated files:
echo   - stm32f103_led_blink.elf (ELF executable)
echo   - stm32f103_led_blink.hex (Intel HEX format)
echo   - stm32f103_led_blink.bin (Binary format)
echo.
echo To flash the firmware:
echo   %MAKE_CMD% flash
echo   or
echo   st-flash write stm32f103_led_blink.bin 0x8000000
echo.
echo Build completed successfully!
pause