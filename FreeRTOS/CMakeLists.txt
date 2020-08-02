# PATH VARIABLES
set(FRTOS_MAIN_DIR ${CMAKE_SOURCE_DIR}/FreeRTOS/Source)
set(FRTOS_HEAP_DIR ${RTOS_MAIN_DIR}/portable/MemMang)
set(FRTOS_MCU_DIR ${RTOS_MAIN_DIR}/portable/GCC/ARM_CM4F)

# STORAGE EVERY *.c FILE in FRTOS_SOURCES
file(GLOB FRTOS_SOURCES
        "${FRTOS_MAIN_DIR}/*.c"
        "${FRTOS_MAIN_DIR}/CMSIS_RTOS/*.c"
        "${FRTOS_MCU_DIR}/*.c"
        ${FRTOS_HEAP_DIR}/heap_5.c
        )

# create a FreeRTOS Library
add_library(frtos_lib ${FRTOS_SOURCES})

# target FreeRTOS include directories
target_include_directories(frtos_lib PUBLIC
        ${FRTOS_MCU_DIR}
        ${CMAKE_SOURCE_DIR}/CMSIS/core
        ${FRTOS_MAIN_DIR}/include
        ${FRTOS_MAIN_DIR}/CMSIS_RTOS
        )