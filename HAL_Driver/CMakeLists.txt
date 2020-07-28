# PATH VARIABLES
set(HAL_MAIN_DIR ${CMAKE_SOURCE_DIR}/HAL_Driver)
set(CMSIS_MAIN_DIR ${CMAKE_SOURCE_DIR}/CMSIS)

# STORAGE EVERY *.c FILE in HAL_SOURCES
# IT BASE ON ${HAL_MAIN_DIR}/Src AND ${HAL_MAIN_DIR}/Src/Legacy DIRECTORIES
file(GLOB HAL_SOURCES
        "${HAL_MAIN_DIR}/Src/*.c"
        "${HAL_MAIN_DIR}/Src/Legacy/*.c"
        )

# create a HAL Library
add_library(hal_lib ${HAL_SOURCES})

# -Wno-attributes flag makes that code warning gonna be vanished
target_compile_options(hal_lib PUBLIC -Wno-attributes)

# target HAL include directories
target_include_directories(hal_lib PUBLIC
        ${HAL_MAIN_DIR}/Inc
        ${HAL_MAIN_DIR}/Inc/Legacy
        )

# target CMSIS include directories
target_include_directories(hal_lib PUBLIC
        ${CMSIS_MAIN_DIR}/core
        ${CMSIS_MAIN_DIR}/device/
        )