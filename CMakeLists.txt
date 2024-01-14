cmake_minimum_required(VERSION 3.14)
set(CMAKE_C_STANDARD 11)

set(ENVSDK $ENV{PLAYDATE_SDK_PATH})

if (NOT ${ENVSDK} STREQUAL "")
    # Convert path from Windows
    file(TO_CMAKE_PATH ${ENVSDK} SDK)
else()
    execute_process(
            COMMAND bash -c "egrep '^\\s*SDKRoot' $HOME/.Playdate/config"
            COMMAND head -n 1
            COMMAND cut -c9-
            OUTPUT_VARIABLE SDK
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
endif()

if (NOT EXISTS ${SDK})
    message(FATAL_ERROR "SDK Path not found; set ENV value PLAYDATE_SDK_PATH")
    return()
endif()

set(CMAKE_CONFIGURATION_TYPES "Debug;Release")
set(CMAKE_XCODE_GENERATE_SCHEME TRUE)

# Game Name Customization
set(PLAYDATE_GAME_NAME package_resolved)
set(PLAYDATE_GAME_DEVICE package_resolved_DEVICE)

project(${PLAYDATE_GAME_NAME} C ASM)

# set(TARGET_GROUP production STRING "Group to build")

project(${PLAYDATE_GAME_NAME} C ASM)

# Unit testing
if(TARGET_GROUP STREQUAL "test")
    message("Wow")
    include(CTest)
    add_subdirectory(external)
    add_subdirectory(test)
else()
   message("oof")
   if (TOOLCHAIN STREQUAL "armgcc")
       add_executable(${PLAYDATE_GAME_DEVICE} src/main.c src/images.c src/movement.c src/vector.c)
   else()
       add_library(${PLAYDATE_GAME_NAME} SHARED src/main.c src/images.c src/movement.c src/vector.c )
   endif()
   
   include(${SDK}/C_API/buildsupport/playdate_game.cmake)
endif()