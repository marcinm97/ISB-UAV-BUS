cmake_minimum_required(VERSION 3.7)

file(TO_CMAKE_PATH "${PROJECT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")
    message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file).
     Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

option(BUILD_UTESTS "Build all unit tests" OFF)

macro(add_subdirectories)
    foreach(dir IN ITEMS ${ARGN})
        add_subdirectory(${dir})
    endforeach()
endmacro()


if (${BUILD_UTESTS})
    message("USING GCC/G++ - RUNNING UNIT TESTS")
    PROJECT(ISB-UAVBus C CXX ASM)
    enable_testing()

    # control tests launching
    option(BLUETOOTH_UTEST_ENABLED  "Run Bluetooth module unit tests"  OFF)
    option(SDCARD_UTEST_ENABLED     "Run SDCard module unit tests"     OFF)
    option(RXTXFrames_UTEST_ENABLED "Run RXTXFrames module unit tests" OFF)


    #    add_subdirectories(Bluetooth
    #                       SDCard
    #                       RXTXFrames
    #                       )

else()

    message("USING ARM-NONE-EABI-GCC")
    include(cmake/armsetup.cmake)

    PROJECT(ISB-UAVBus C CXX ASM)

    # TODO: to automation - file(...)
    set(ISB_SOURCES
            ${CMAKE_SOURCE_DIR}/Src/main.c
            ${CMAKE_SOURCE_DIR}/Src/stm32f4xx_it.c
            ${CMAKE_SOURCE_DIR}/Src/syscalls.c
            ${CMAKE_SOURCE_DIR}/Src/system_stm32f4xx.c
            )

    set(ISB_HEADERS
            ${CMAKE_SOURCE_DIR}/Inc/stm32f4xx_it.h
            )

    # ThirdParty libs

    # HAL LIBRARY               - SUBDIR (own CMakeLists.txt)
    # CMSIS LIBRARY             - SUBDIR (own CMakeLists.txt)
    # FreeRTOS LIBRARY          - SUBDIR (own CMakeLists.txt)
    # TESTS DIRECTORY           - SUBDIR (own CMakeLists.txt)

    add_subdirectories(HAL_Driver
            FreeRTOS
            #CMSIS

            #Bluetooth
            #SDCard
            #RXTXFrames

            #tests
            )

    # ALLOWS TO INCLUDE INC HEADERS IN CODE
    include_directories(${CMAKE_SOURCE_DIR}/Inc)


    # MAIN EXECUTABLE
    add_executable(${PROJECT_NAME}.elf
            ${ISB_SOURCES} ${ISB_HEADERS}
            ${ASSEMBLY_STARTUP}
            ${LINKER_SCRIPT}
            )

    target_link_libraries(${PROJECT_NAME}.elf PUBLIC
            hal_lib
            frtos_lib
            )


    set(CMAKE_EXE_LINKER_FLAGS
            "${CMAKE_EXE_LINKER_FLAGS} -Wl,-Map=${PROJECT_BINARY_DIR}/${PROJECT_NAME}.map")

    set(HEX_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.hex)
    set(BIN_FILE ${PROJECT_BINARY_DIR}/${PROJECT_NAME}.bin)

    add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
            COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${PROJECT_NAME}.elf> ${HEX_FILE}
            COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${PROJECT_NAME}.elf> ${BIN_FILE}
            COMMENT "Building ${HEX_FILE}
    Building ${BIN_FILE}")
endif ()
