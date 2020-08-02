SET(CMAKE_SYSTEM_NAME Generic)
SET(CMAKE_SYSTEM_VERSION 1)
cmake_minimum_required(VERSION 3.7)

# specify cross compilers and tools
SET(CMAKE_C_COMPILER_WORKS 1)
SET(CMAKE_C_COMPILER arm-none-eabi-gcc)
SET(CMAKE_CXX_COMPILER_WORKS 1)
SET(CMAKE_CXX_COMPILER arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER  arm-none-eabi-gcc)
set(CMAKE_AR arm-none-eabi-ar)
set(CMAKE_OBJCOPY arm-none-eabi-objcopy)
set(CMAKE_OBJDUMP arm-none-eabi-objdump)
set(SIZE arm-none-eabi-size)

SET(LINKER_SCRIPT ${CMAKE_SOURCE_DIR}/STM32F446RETx_FLASH.ld)

# hardware floating point
#SET(FPU_FLAGS "-mfloat-abi=hard -mfpu=fpv4-sp-d16")
#add_definitions(-DARM_MATH_CM4 -DARM_MATH_MATRIX_CHECK -DARM_MATH_ROUNDING -D__FPU_PRESENT=1)

# software floating point
#SET(FPU_FLAGS "-mfloat-abi=soft")

SET(COMMON_FLAGS
    "-mcpu=cortex-m4 ${FPU_FLAGS} -mthumb -mthumb-interwork -ffunction-sections -fdata-sections \
    -g -fno-common -fmessage-length=0 -specs=nosys.specs -specs=nano.specs")

SET(CMAKE_CXX_FLAGS_INIT "${COMMON_FLAGS} -std=c++11")
SET(CMAKE_C_FLAGS_INIT "${COMMON_FLAGS} -std=gnu99")
SET(CMAKE_EXE_LINKER_FLAGS_INIT "-Wl,-gc-sections,--print-memory-usage -T ${LINKER_SCRIPT}")

PROJECT(ISB-UAVBus C CXX ASM)

#add_definitions(-DARM_MATH_CM4 -DARM_MATH_MATRIX_CHECK -DARM_MATH_ROUNDING -D__FPU_PRESENT=1)
add_definitions(-DUSE_HAL_DRIVER -DSTM32F446xx)


set(ASSEMBLY_STARTUP ${CMAKE_SOURCE_DIR}/startup/startup_stm32f446xx.s)

set(ISB_SOURCES
        ${CMAKE_SOURCE_DIR}/Src/main.c
        ${CMAKE_SOURCE_DIR}/Src/stm32f4xx_it.c
        ${CMAKE_SOURCE_DIR}/Src/syscalls.c
        ${CMAKE_SOURCE_DIR}/Src/system_stm32f4xx.c
        )

set(ISB_HEADERS
        ${CMAKE_SOURCE_DIR}/Inc/FreeRTOSConfig.h
        ${CMAKE_SOURCE_DIR}/Inc/stm32f4xx_it.h
        )

# ThirdParty libs

# HAL LIBRARY               - SUBDIR (own CMakeLists.txt)
add_subdirectory(HAL_Driver)

# CMSIS LIBRARY             - SUBDIR (own CMakeLists.txt)
#add_subdirectory(CMSIS)

# FreeRTOS LIBRARY          - SUBDIR (own CMakeLists.txt)
#add_subdirectory(FreeRTOS)

# ALLOWS TO INCLUDE INC HEADERS IN CODE
include_directories(${CMAKE_SOURCE_DIR}/Inc)

# MAIN EXECUTABLE
add_executable(${PROJECT_NAME}.elf
        ${ISB_SOURCES} ${ISB_HEADERS}
        ${ASSEMBLY_STARTUP}
        ${LINKER_SCRIPT})

target_link_libraries(${PROJECT_NAME}.elf PUBLIC hal_lib)


set(CMAKE_EXE_LINKER_FLAGS
    "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map")

set(HEX_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.hex)
set(BIN_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin)

add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
        COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
        COMMENT "Building ${HEX_FILE}
Building ${BIN_FILE}")
