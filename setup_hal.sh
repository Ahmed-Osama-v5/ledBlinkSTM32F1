#!/bin/bash

# Script to download and setup STM32F1 HAL library
# This script downloads the HAL library from the official STM32CubeF1 repository

set -e

echo "=== STM32F1 HAL Library Setup ==="

HAL_URL="https://github.com/STMicroelectronics/STM32CubeF1.git"
TEMP_DIR="temp_stm32cube"
HAL_VERSION="v1.8.5"  # Latest stable version

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "Error: git is required but not installed."
    echo "Please install git and try again."
    exit 1
fi

# Check if hal directory already exists
if [ -d "hal/Inc" ] && [ -d "hal/Src" ]; then
    echo "HAL library already exists. Skipping download."
    echo "To force re-download, remove the hal/ directory first."
    exit 0
fi

echo "Downloading STM32CubeF1 repository..."
git clone --depth 1 --branch $HAL_VERSION $HAL_URL $TEMP_DIR

echo "Copying HAL library files..."
mkdir -p hal

# Copy HAL Inc and Src directories
cp -r $TEMP_DIR/Drivers/STM32F1xx_HAL_Driver/Inc hal/
cp -r $TEMP_DIR/Drivers/STM32F1xx_HAL_Driver/Src hal/

# Copy CMSIS device files
mkdir -p hal/CMSIS
cp -r $TEMP_DIR/Drivers/CMSIS/Device/ST/STM32F1xx/Include hal/CMSIS/
cp -r $TEMP_DIR/Drivers/CMSIS/Include hal/CMSIS/

echo "Cleaning up..."
rm -rf $TEMP_DIR

echo ""
echo "=== HAL Library Setup Complete ==="
echo "HAL library has been downloaded and set up in the hal/ directory."
echo "You can now build the project using ./build.sh"
echo ""
echo "HAL library structure:"
echo "  hal/Inc/           - HAL header files"
echo "  hal/Src/           - HAL source files"
echo "  hal/CMSIS/Include/ - CMSIS core headers"
echo "  hal/CMSIS/         - STM32F1xx device headers"