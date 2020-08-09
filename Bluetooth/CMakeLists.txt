
file(GLOB BTH_HEADER "${CMAKE_CURRENT_SOURCE_DIR}/inc/*.h")
file(GLOB BTH_SRC "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c")

set(TEST_SRC ${CMAKE_CURRENT_SOURCE_DIR}/tests/bluetooth_test.cpp)

add_executable(bluetooth_test ${TEST_SRC} ${BTH_SRC})

target_compile_options(bluetooth_test PRIVATE -Wall -Wextra -Wpedantic -Werror)

target_include_directories(bluetooth_test PUBLIC ${BTH_HEADER})

target_link_libraries(bluetooth_test PUBLIC gtest_main)

add_custom_command(TARGET bluetooth_test
        POST_BUILD
        COMMAND bluetooth_test
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        COMMENT "Running bluetooth_test" VERBATIM
                  )

add_test(
        NAME bth_test
        COMMAND bth_test
        )

