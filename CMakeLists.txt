# Load all of the scripts on add_subdirectory(build_scripts)

set(BUILD_SCRIPTS_PATH ${CMAKE_CURRENT_SOURCE_DIR})
file(GLOB build_scripts RELATIVE ${BUILD_SCRIPTS_PATH} ${BUILD_SCRIPTS_PATH}/*.cmake)

message(STATUS "Including build scripts: ${build_scripts}")
foreach(script ${build_scripts})
    include(${BUILD_SCRIPTS_PATH}/${script})
endforeach()