#!/bin/bash

# STM32F103 LED Blink Project Build Script
# This script builds the project using CMake and ARM GCC toolchain

set -e  # Exit on any error

echo "=== STM32F103 LED Blink Project Build Script ==="

# Check if HAL library exists
if [ ! -d "hal/Inc" ]; then
    echo "Error: STM32 HAL library not found!"
    echo "Please run setup_hal.sh first to download the HAL library."
    echo ""
    echo "Run: ./setup_hal.sh"
    echo "Then: ./build.sh"
    exit 1
fi

# Check if ARM GCC toolchain is installed
if ! command -v arm-none-eabi-gcc &> /dev/null; then
    echo "Error: ARM GCC toolchain not found!"
    echo "Please install arm-none-eabi-gcc toolchain:"
    echo "  Ubuntu/Debian: sudo apt install gcc-arm-none-eabi"
    echo "  macOS: brew install arm-none-eabi-gcc"
    echo "  Windows: Download from ARM website"
    exit 1
fi

# Check if CMake is installed
if ! command -v cmake &> /dev/null; then
    echo "Error: CMake not found!"
    echo "Please install CMake:"
    echo "  Ubuntu/Debian: sudo apt install cmake"
    echo "  macOS: brew install cmake"
    echo "  Windows: Download from cmake.org"
    exit 1
fi

# Create build directory if it doesn't exist
if [ ! -d "build" ]; then
    mkdir build
fi

# Navigate to build directory
cd build

echo "Configuring project with CMake..."
cmake ..

echo "Building project..."
make -j$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)

echo ""
echo "=== Build Complete ==="
echo "Generated files:"
echo "  - stm32f103_led_blink.elf (ELF executable)"
echo "  - stm32f103_led_blink.hex (Intel HEX format)"
echo "  - stm32f103_led_blink.bin (Binary format)"
echo ""
echo "To flash the firmware:"
echo "  make flash"
echo "  or"
echo "  st-flash write stm32f103_led_blink.bin 0x8000000"
echo ""
echo "Build completed successfully!"