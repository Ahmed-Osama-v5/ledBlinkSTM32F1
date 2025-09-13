cmake_minimum_required(VERSION 3.16)

# Set the toolchain before project declaration
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_CURRENT_SOURCE_DIR}/cmake/arm-none-eabi-gcc.cmake)

# Project configuration
project(stm32f103_led_blink C ASM)

# Set C standard
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

# MCU specific settings
set(MCU_FAMILY STM32F1xx)
set(MCU_MODEL STM32F103xB)
set(CPU_PARAMETERS
    -mcpu=cortex-m3
    -mthumb
    -mfloat-abi=soft
)

# Convert list to space-separated string
string(REPLACE ";" " " CPU_PARAMETERS_STR "${CPU_PARAMETERS}")

# Compiler flags
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${CPU_PARAMETERS_STR}")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra -Wpedantic -Wno-unused-parameter")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fdata-sections -ffunction-sections")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g3 -O0")

set(CMAKE_ASM_FLAGS "${CMAKE_C_FLAGS} -x assembler-with-cpp")

# Linker flags
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${CPU_PARAMETERS_STR}")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -T${CMAKE_CURRENT_SOURCE_DIR}/STM32F103C8Tx_FLASH.ld")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --specs=nano.specs")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--gc-sections")
set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -Wl,--print-memory-usage")

# Definitions
add_definitions(-DUSE_HAL_DRIVER)
add_definitions(-D${MCU_MODEL})

# Include directories
include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/include
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Inc
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Inc/Legacy
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/CMSIS/Include
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/CMSIS/
)

# HAL source files - only include the ones we need
set(HAL_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_cortex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_dma.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_flash.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_flash_ex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_gpio.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_gpio_ex.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_pwr.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_rcc.c
    ${CMAKE_CURRENT_SOURCE_DIR}/hal/Src/stm32f1xx_hal_rcc_ex.c
)

# Project source files
set(PROJECT_SOURCES
    ${CMAKE_CURRENT_SOURCE_DIR}/src/main.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/system_stm32f1xx.c
    ${CMAKE_CURRENT_SOURCE_DIR}/src/stm32f1xx_it.c
    ${CMAKE_CURRENT_SOURCE_DIR}/startup/startup_stm32f103xb.s
    ${HAL_SOURCES}
)

# Create executable
add_executable(${PROJECT_NAME}.elf ${PROJECT_SOURCES})

# Create hex and bin files
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary $<TARGET_FILE:${PROJECT_NAME}.elf> ${PROJECT_NAME}.bin
    COMMENT "Building ${PROJECT_NAME}.hex and ${PROJECT_NAME}.bin"
)

# Print size information
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_SIZE} $<TARGET_FILE:${PROJECT_NAME}.elf>
    COMMENT "Size information:"
)

# Flash target
add_custom_target(flash
    COMMAND st-flash write ${PROJECT_NAME}.bin 0x8000000
    DEPENDS ${PROJECT_NAME}.elf
    COMMENT "Flashing ${PROJECT_NAME}.bin to STM32F103"
)