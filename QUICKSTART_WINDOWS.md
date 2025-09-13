# Quick Start Guide for Windows

This is a simplified guide to get you started quickly on Windows.

## Prerequisites

1. **Install ARM GCC Toolchain**:
   - Download from: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm
   - Or use Chocolatey: `choco install gcc-arm-embedded`

2. **Install CMake**:
   - Download from: https://cmake.org/download/
   - Or use Chocolatey: `choco install cmake`

3. **Install Git**:
   - Download from: https://git-scm.com/download/win

## Quick Build Steps

1. **Download HAL Library**:
   ```cmd
   setup_hal.bat
   ```

2. **Build the Project**:
   ```cmd
   build.bat
   ```

3. **Flash to Hardware** (if you have ST-Link):
   ```cmd
   cd build
   st-flash write stm32f103_led_blink.bin 0x8000000
   ```

## Troubleshooting

- **"arm-none-eabi-gcc is not recognized"**: Add the ARM GCC bin directory to your PATH
- **"cmake is not recognized"**: Add CMake bin directory to your PATH  
- **"mingw32-make is not recognized"**: The build script will use `cmake --build .` instead
- **Git clone fails**: Check your internet connection and firewall settings

## Hardware Setup

- Connect ST-Link V2 to your STM32F103 Blue Pill board
- The LED on PC13 will start blinking after successful flash

For detailed information, see the main README.md file.