################
### TESTING: ###
################
function(CHECK_IF_TEST_ENABLED result)
    list(FIND TEST_TARGETS ${PROJECT_NAME} test_enabled)
    if (test_enabled EQUAL -1)
        set(${result} False PARENT_SCOPE)
        message(STATUS "Skipping \"${PROJECT_NAME}\" test.")
    else()
        set(${result} True PARENT_SCOPE)
        message(STATUS "Listed \"${PROJECT_NAME}\" test.")
    endif()
endfunction(CHECK_IF_TEST_ENABLED)


function(INCLUDE_GTEST)
    FetchContent_MakeAvailable(googletest)
endfunction(INCLUDE_GTEST)


# testing effectiveness of configuration flags on the build
function(CONFIGURATION_TEST test source flags link_libs expected)
    add_executable(${test} ${source})
    target_compile_options(${test} PUBLIC ${flags})
    target_link_libraries(${test} ${link_libs})

    add_test(NAME ${test} COMMAND ${test})

    set_tests_properties(${test} PROPERTIES 
        PASS_REGULAR_EXPRESSION ${expected}
    ) 
endfunction(CONFIGURATION_TEST)


# call this inside tests/CMakeLists.txt
function(SETUP_TESTING)
    check_if_test_enabled(test_enabled)
    if (test_enabled)
        message(STATUS "Testing \"${PROJECT_NAME}\"")

        # collecting tests 
        file(GLOB_RECURSE test_sources ${CMAKE_CURRENT_SOURCE_DIR}/*.cpp)
        
        include(GoogleTest)
        
        foreach(test_source ${test_sources})
            cmake_path(GET test_source FILENAME test_name)
            list(APPEND test_targets ${test_name})

            add_executable(${test_name} ${test_source})
            
            target_link_libraries(${test_name} 
                PRIVATE ${PROJECT_NAME}
                PRIVATE gtest_main
            )
            
            set_target_properties(${test_name} PROPERTIES CXX_STANDARD 20)
            add_test(NAME ${test_name} COMMAND ${test_name})

            gtest_discover_tests(${test_name})
        endforeach()

        if (NOT test_sources)
            message(STATUS "${PROJECT_NAME} tests not found!")
        endif()
        
    endif() # test_enabled
endfunction(SETUP_TESTING)