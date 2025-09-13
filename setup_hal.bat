@echo off
REM Script to download and setup STM32F1 HAL library for Windows
REM This script downloads the HAL library from the official STM32CubeF1 repository

echo === STM32F1 HAL Library Setup ===

set HAL_URL=https://github.com/STMicroelectronics/STM32CubeF1.git
set TEMP_DIR=temp_stm32cube
set HAL_VERSION=v1.8.5

REM Check if git is available
where git >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: git is required but not installed.
    echo Please install git from: https://git-scm.com/download/win
    echo Or use chocolatey: choco install git
    echo Or use scoop: scoop install git
    pause
    exit /b 1
)

REM Check if hal directory already exists
if exist "hal\Inc" if exist "hal\Src" (
    echo HAL library already exists. Skipping download.
    echo To force re-download, remove the hal\ directory first.
    pause
    exit /b 0
)

echo Downloading STM32CubeF1 repository...
git clone --depth 1 --branch %HAL_VERSION% %HAL_URL% %TEMP_DIR%
if %errorlevel% neq 0 (
    echo Failed to download STM32CubeF1 repository!
    pause
    exit /b 1
)

echo Copying HAL library files...
if not exist "hal" mkdir hal

REM Copy HAL Inc and Src directories
xcopy "%TEMP_DIR%\Drivers\STM32F1xx_HAL_Driver\Inc" "hal\Inc\" /E /I /Y
xcopy "%TEMP_DIR%\Drivers\STM32F1xx_HAL_Driver\Src" "hal\Src\" /E /I /Y

REM Copy CMSIS device files
if not exist "hal\CMSIS" mkdir "hal\CMSIS"
xcopy "%TEMP_DIR%\Drivers\CMSIS\Device\ST\STM32F1xx\Include" "hal\CMSIS\" /E /I /Y
xcopy "%TEMP_DIR%\Drivers\CMSIS\Include" "hal\CMSIS\Include\" /E /I /Y

echo Cleaning up...
rmdir /s /q %TEMP_DIR%

echo.
echo === HAL Library Setup Complete ===
echo HAL library has been downloaded and set up in the hal\ directory.
echo You can now build the project using build.bat
echo.
echo HAL library structure:
echo   hal\Inc\           - HAL header files
echo   hal\Src\           - HAL source files
echo   hal\CMSIS\Include\ - CMSIS core headers
echo   hal\CMSIS\         - STM32F1xx device headers
pause