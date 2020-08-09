# TODO: unit test libs target

function(add_gmock_test target)
    add_executable(${target} ${ARGN})
    target_link_libraries(${target} gmock_main)

    add_test(${target} ${target})

    add_custom_command(TARGET ${target}
            POST_BUILD
            COMMAND ${target}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMENT "Running ${target}" VERBATIM)
endfunction()

add_subdirectory(googletest)