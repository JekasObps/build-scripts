# checks os and build-mode, set appropriet flags
macro(CHECK_BUILD)
    # checking an OS which we build for and setting flags
    if (WIN32)
        message(STATUS "OS: WINDOWS")
        add_definitions(-DWIN32)
    elseif (UNIX AND NOT APPLE)
        message(STATUS "OS: LINUX")
        add_definitions(-DLINUX)
        set(LINUX True)
    endif()
       
    if (DEFINED CMAKE_BUILD_TYPE)
    else()
        set(CMAKE_BUILD_TYPE Debug)
    endif()
    
    # checking build type and setting appropriate flags
    if (${CMAKE_BUILD_TYPE} STREQUAL Debug)
        message(STATUS "SET DEBUG_MODE")
        add_definitions(-DDEBUG_MODE)
    elseif (${CMAKE_BUILD_TYPE} STREQUAL Release)
        message(STATUS "SET RELEASE")
        add_definitions(-DNDEBUG)
    endif()
endmacro(CHECK_BUILD)


# if the project is the main one sets ${PROJECT_NAME}_MAIN_PROJECT
macro(CHECK_MAIN_PROJECT)
    # Determine if a project is a main project
    if (CMAKE_CURRENT_SOURCE_DIR STREQUAL CMAKE_SOURCE_DIR)
        set(${PROJECT_NAME}_MAIN_PROJECT ON)
    endif()
endmacro(CHECK_MAIN_PROJECT)
