# STM32F103 LED Blink Project

[![CI/CD Pipeline](https://github.com/Ahmed-Osama-v5/ledBlinkSTM32F1/actions/workflows/ci.yml/badge.svg)](https://github.com/Ahmed-Osama-v5/ledBlinkSTM32F1/actions/workflows/ci.yml)
[![Release](https://github.com/Ahmed-Osama-v5/stm32f103-led-blink/actions/workflows/release.yml/badge.svg)](https://github.com/Ahmed-Osama-v5/stm32f103-led-blink/actions/workflows/release.yml)

A simple LED blinking project for STM32F103 microcontroller using CMake build system and STM32 HAL library.

## Features

- **Target MCU**: STM32F103C8T6 (Blue Pill board)
- **Build System**: CMake with ARM GCC toolchain
- **HAL Library**: STM32F1xx HAL drivers
- **LED Control**: Built-in LED on PC13 blinks every 500ms
- **Clock Configuration**: 72MHz system clock using external 8MHz crystal
- **Memory**: 64KB Flash, 20KB RAM

## Project Structure

```
├── build/                  # Build output directory
├── cmake/                  # CMake toolchain files
│   └── arm-none-eabi-gcc.cmake
├── hal/                    # STM32 HAL library (downloaded by setup script)
│   ├── Inc/               # HAL header files
│   ├── Src/               # HAL source files
│   └── CMSIS/             # CMSIS headers
├── include/               # Project header files
│   ├── main.h
│   ├── stm32f1xx_hal_conf.h
│   └── stm32f1xx_it.h
├── src/                   # Project source files
│   ├── main.c
│   ├── system_stm32f1xx.c
│   └── stm32f1xx_it.c
├── startup/               # Startup assembly files
│   └── startup_stm32f103xb.s
├── CMakeLists.txt         # Main CMake configuration
├── STM32F103C8Tx_FLASH.ld # Linker script
├── build.sh              # Build script (Linux/macOS)
├── build.bat             # Build script (Windows)
├── build.ps1             # Build script (PowerShell)
├── setup_hal.sh          # HAL setup script (Linux/macOS)
├── setup_hal.bat         # HAL setup script (Windows)
├── .gitignore            # Git ignore file
└── README.md             # This file
```

## Prerequisites

### Required Tools

1. **ARM GCC Toolchain**
   - Ubuntu/Debian: `sudo apt install gcc-arm-none-eabi`
   - macOS: `brew install arm-none-eabi-gcc`
   - Windows:
     - Download from [ARM Developer website](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm)
     - Or use Chocolatey: `choco install gcc-arm-embedded`
     - Or use Scoop: `scoop install gcc-arm-none-eabi`

2. **CMake** (version 3.16 or higher)
   - Ubuntu/Debian: `sudo apt install cmake`
   - macOS: `brew install cmake`
   - Windows:
     - Download from [cmake.org](https://cmake.org/download/)
     - Or use Chocolatey: `choco install cmake`
     - Or use Scoop: `scoop install cmake`

3. **Make Utility** (Windows only)
   - Usually included with ARM GCC toolchain
   - Or install MinGW: `choco install mingw`
   - CMake can also build without make: `cmake --build .`

4. **Git** (for downloading HAL library)
   - Ubuntu/Debian: `sudo apt install git`
   - macOS: `brew install git` or use Xcode Command Line Tools
   - Windows: Download from [git-scm.com](https://git-scm.com/download/win)

5. **STM32 HAL Library** (automatically downloaded by setup script)
   - Run `setup_hal.bat` (Windows) or `./setup_hal.sh` (Linux/macOS)
   - Or manually download STM32CubeF1 from [STMicroelectronics website](https://www.st.com/en/embedded-software/stm32cubef1.html)

6. **ST-Link Tools** (for flashing)
   - Ubuntu/Debian: `sudo apt install stlink-tools`
   - macOS: `brew install stlink`
   - Windows: Download ST-Link Utility from STMicroelectronics

### Setting up HAL Library

1. Download STM32CubeF1 package
2. Copy the following directories to your project:
   ```bash
   # From STM32Cube_FW_F1_VX.X.X/Drivers/STM32F1xx_HAL_Driver/
   cp -r Inc/ hal/
   cp -r Src/ hal/
   ```

## Building the Project

### Windows Users

#### Option 1: Using Batch File (Recommended)
```cmd
setup_hal.bat
build.bat
```

#### Option 2: Using PowerShell
```powershell
.\setup_hal.bat
.\build.ps1
```

#### Option 3: Manual Build (Windows)
```cmd
mkdir build
cd build
cmake -G "MinGW Makefiles" ..
mingw32-make -j4
```

### Linux/macOS Users

#### Using the Build Script (Recommended)
```bash
./setup_hal.sh
./build.sh
```

#### Manual Build
```bash
mkdir -p build
cd build
cmake ..
make -j4
```

## Flashing the Firmware

### Using Make Target

```bash
cd build
make flash
```

### Using ST-Link Directly

```bash
cd build
st-flash write stm32f103_led_blink.bin 0x8000000
```

### Using OpenOCD

```bash
openocd -f interface/stlink.cfg -f target/stm32f1x.cfg -c "program stm32f103_led_blink.elf verify reset exit"
```

## Hardware Setup

### STM32F103C8T6 Blue Pill Board

- **LED**: Built-in LED connected to PC13 (active low)
- **Crystal**: 8MHz external crystal for HSE
- **Power**: 3.3V via USB or external supply
- **Programming**: ST-Link V2 or compatible programmer

### Connections

| Function | Pin | Description |
|----------|-----|-------------|
| LED | PC13 | Built-in LED (active low) |
| SWDIO | PA13 | SWD Data |
| SWCLK | PA14 | SWD Clock |
| NRST | NRST | Reset |
| VCC | 3V3 | Power Supply |
| GND | GND | Ground |

## Configuration

### Clock Configuration

- **HSE**: 8MHz external crystal
- **PLL**: HSE × 9 = 72MHz
- **SYSCLK**: 72MHz
- **AHB**: 72MHz
- **APB1**: 36MHz
- **APB2**: 72MHz

### GPIO Configuration

- **PC13**: Output, Push-Pull, Low Speed
- **LED Logic**: Active Low (0 = ON, 1 = OFF)

## Customization

### Changing Blink Rate

Edit `src/main.c` and modify the delay value:

```c
/* Change from 500ms to desired delay */
HAL_Delay(500);  // 500ms = 0.5 seconds
```

### Using Different LED Pin

1. Update `include/main.h`:
   ```c
   #define LED_Pin GPIO_PIN_XX
   #define LED_GPIO_Port GPIOX
   ```

2. Update GPIO clock enable in `src/main.c`:
   ```c
   __HAL_RCC_GPIOX_CLK_ENABLE();
   ```

### Adding More Features

- **UART Communication**: Enable USART1/2/3 in HAL config
- **Timer PWM**: Use TIM2/3/4 for PWM LED control
- **External Interrupts**: Add button input on EXTI lines
- **ADC**: Read analog sensors
- **I2C/SPI**: Interface with external devices

## Troubleshooting

### Build Issues

1. **Toolchain not found**: Ensure ARM GCC is in PATH
2. **HAL files missing**: Download and extract STM32CubeF1
3. **CMake errors**: Check CMake version (≥3.16 required)

### Flashing Issues

1. **ST-Link not detected**: Check USB connection and drivers
2. **Target not found**: Verify wiring and power supply
3. **Flash protection**: Use ST-Link Utility to disable read protection

### Runtime Issues

1. **LED not blinking**: Check pin configuration and wiring
2. **System not starting**: Verify clock configuration
3. **Hard fault**: Enable debug symbols and use debugger

## Development Environment

### Recommended IDEs

- **VS Code** with C/C++ and CMake extensions
- **STM32CubeIDE** (Eclipse-based)
- **CLion** with embedded development plugin
- **Vim/Neovim** with appropriate plugins

### Debugging

```bash
# Using OpenOCD and GDB
openocd -f interface/stlink.cfg -f target/stm32f1x.cfg
arm-none-eabi-gdb build/stm32f103_led_blink.elf
## CI/CD Pipeline

This project includes a comprehensive GitHub Actions CI/CD pipeline with the following stages:

### Automated Workflows

#### 1. **CI/CD Pipeline** (`.github/workflows/ci.yml`)
Triggered on push to `main`/`develop` branches and pull requests:

- **Static Analysis Stage**
  - **Cppcheck**: Comprehensive static analysis for C/C++ code
  - **Clang-Tidy**: Modern C++ linting and static analysis
  - **Custom suppressions**: Configured to ignore HAL library false positives

- **Build Stage**
  - **Multi-configuration**: Builds both Debug and Release versions
  - **ARM GCC Toolchain**: Automatically installs latest ARM GCC
  - **Memory Analysis**: Reports flash/RAM usage for each build
  - **Artifact Upload**: Stores `.elf`, `.hex`, and `.bin` files

- **Security Scan Stage**
  - **Semgrep**: Security vulnerability scanning
  - **Bandit**: Python security analysis (if Python scripts present)

- **Documentation Stage**
  - **Doxygen**: Automatic API documentation generation
  - **Artifact Upload**: Stores generated documentation

#### 2. **Release Workflow** (`.github/workflows/release.yml`)
Triggered on version tags (e.g., `v1.0.0`):

- Builds optimized release firmware
- Generates detailed release notes with memory usage
- Creates GitHub release with firmware binaries
- Automatically uploads `.elf`, `.hex`, and `.bin` files

### Configuration Files

- **`.cppcheck-suppressions`**: Suppresses false positives from HAL library
- **`.clang-tidy`**: Configures modern C++ checks appropriate for embedded development

### Using the CI/CD Pipeline

1. **Automatic Builds**: Every push triggers the full pipeline
2. **Pull Request Checks**: All PRs must pass CI before merging
3. **Release Creation**: Push a version tag to create a release:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. **Artifact Download**: Build artifacts are available for 30 days
5. **Status Badges**: README shows current build status

### Local Static Analysis

Run the same checks locally:

```bash
# Install tools
sudo apt install cppcheck clang-tidy

# Generate compile commands
mkdir build && cd build
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ..

# Run static analysis
cppcheck --enable=all --project=compile_commands.json
run-clang-tidy -p .
```

## License

This project is provided as-is for educational and development purposes.

## Contributing

Feel free to submit issues and enhancement requests!

## References

- [STM32F103 Reference Manual](https://www.st.com/resource/en/reference_manual/rm0008-stm32f101xx-stm32f102xx-stm32f103xx-stm32f105xx-and-stm32f107xx-advanced-armbased-32bit-mcus-stmicroelectronics.pdf)
- [STM32F103 Datasheet](https://www.st.com/resource/en/datasheet/stm32f103c8.pdf)
- [STM32 HAL Documentation](https://www.st.com/resource/en/user_manual/um1850-description-of-stm32f1-hal-and-lowlayer-drivers-stmicroelectronics.pdf)
- [CMake Documentation](https://cmake.org/documentation/)
- [ARM GCC Toolchain](https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm)