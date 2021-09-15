################
### TESTING: ###
################

# populates gdest declared in fetch_googletest.cmake
function(IMPORT_GTEST)
    FetchContent_MakeAvailable(googletest)
endfunction(IMPORT_GTEST)


# testing effectiveness of configuration flags on the build
function(CONFIGURATION_TEST)
    set(oneValueArgs TEST SOURCE EXPECTED)
    set(multiValueArgs FLAGS LINK_LIBS)
    cmake_parse_arguments(CONFT "" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    message(STATUS "Configuration Test: ${CONFT_TEST}")
    add_executable(${CONFT_TEST} ${CONFT_SOURCE})
    target_compile_options(${CONFT_TEST} PUBLIC ${CONFT_FLAGS})
    
    target_link_libraries(${CONFT_TEST} ${CONFT_LINK_LIBS})

    add_test(NAME ${CONFT_TEST} COMMAND ${CONFT_TEST})

    set_tests_properties(${CONFT_TEST} PROPERTIES 
        PASS_REGULAR_EXPRESSION ${CONFT_EXPECTED}
    ) 
endfunction(CONFIGURATION_TEST)


function(ENABLE_ALL_TESTS)
    set(TEST_ALL ON PARENT_SCOPE)
endfunction(ENABLE_ALL_TESTS)


function(ENABLE_TESTS)
    __ENABLE_PROJECT_TESTS(${PROJECT_NAME} ${ARGN})
endfunction(ENABLE_TESTS)


function(ENABLE_SUBPROJECT_TESTS subproject)
    __ENABLE_PROJECT_TESTS(${subproject} ${ARGN})
endfunction(ENABLE_SUBPROJECT_TESTS)


macro(__ENABLE_PROJECT_TESTS project tests)
    if(${project}_TESTS)
        if(${project}_MAIN_PROJECT)
            message(FATAL_ERROR "Main project test targets may not be overridden!")
        else()
            message(STATUS "Testing targets were overridden! :\n    targets: ${${project}_TESTS}")
        endif()
    else()
        __ENABLE_TESTS(${project} ${tests} ${project}_TESTS)
    endif()
endmacro(__ENABLE_PROJECT_TESTS)


macro(__ENABLE_TESTS project tests result)
    list(APPEND test_targets ${tests})
    set(${result} ${test_targets} PARENT_SCOPE)
endmacro(__ENABLE_TESTS)


# call this inside tests/CMakeLists.txt
function(SETUP_TESTING)
    CHECK_PROJECT_TEST_ENABLED(project_test_all)

    # collecting tests 
    file(GLOB_RECURSE test_sources ${CMAKE_CURRENT_SOURCE_DIR}/test_*.cpp)
    
    if(project_test_all)
        message(STATUS "\"${PROJECT_NAME}\"  ALL TESTS   ")
    endif()

    foreach(test_source ${test_sources})
        cmake_path(GET test_source STEM test_name)

        if(NOT project_test_all)
            CHECK_TEST_ENABLED(${test_name} test_enabled)
            if(test_enabled)
                __TEST_SOURCE()
                message(STATUS "Listed \"${PROJECT_NAME}\" test.")
            else()
                message(STATUS "Skipping \"${PROJECT_NAME}\" test.")
            endif()
        else()
            __TEST_SOURCE()
        endif()
    endforeach()

endfunction(SETUP_TESTING)


macro(__TEST_SOURCE)
    include(GoogleTest)
    
    add_executable(${test_name} ${test_source})
    target_link_libraries(${test_name} 
        PRIVATE ${PROJECT_NAME}
        PRIVATE gtest_main
    )

    add_test(NAME ${test_name} COMMAND ${test_name})

    gtest_discover_tests(${test_name})
endmacro(__TEST_SOURCE)


function(CHECK_TEST_ENABLED test result)
    list(FIND ${PROJECT_NAME}_TEST_TARGETS ${test} test_enabled)
    if(test_enabled EQUAL -1)
        set(${result} False PARENT_SCOPE)
    else()
        set(${result} True PARENT_SCOPE)
    endif()
endfunction(CHECK_TEST_ENABLED)


function(CHECK_PROJECT_TEST_ENABLED result)
    if(TEST_ALL)
        set(${result} True PARENT_SCOPE)
    else()
    list(FIND ${PROJECT_NAME}_TESTS "TEST_ALL" ${result})
    if(${result} EQUAL -1)
        set(${result} False PARENT_SCOPE)
    else()
        set(${result} True PARENT_SCOPE)
    endif()
    endif()
endfunction(CHECK_PROJECT_TEST_ENABLED)
