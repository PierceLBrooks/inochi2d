cmake_minimum_required(VERSION 3.10)

include(FetchContent)

project(Inochi2D)

set(SFML_VERSION "master")

FetchContent_Declare(
    sfml
    GIT_REPOSITORY "https://github.com/SFML/SFML.git"
    GIT_TAG        "${SFML_VERSION}"
)

FetchContent_GetProperties(sfml)

if(NOT sfml_POPULATED)
    FetchContent_Populate(sfml)
    add_subdirectory(${sfml_SOURCE_DIR} ${sfml_BINARY_DIR})
endif()

add_library(libinochi2d STATIC IMPORTED)
set_target_properties(libinochi2d PROPERTIES IMPORTED_LOCATION ${CMAKE_CURRENT_LIST_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}inochi2d${CMAKE_STATIC_LIBRARY_SUFFIX})

add_library(libdruntime STATIC IMPORTED)
set_target_properties(libdruntime PROPERTIES IMPORTED_LOCATION $ENV{DRUNTIME_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}druntime-ldc${CMAKE_STATIC_LIBRARY_SUFFIX})

add_library(libphobos STATIC IMPORTED)
set_target_properties(libphobos PROPERTIES IMPORTED_LOCATION $ENV{DRUNTIME_LIBS}/${CMAKE_STATIC_LIBRARY_PREFIX}phobos2-ldc${CMAKE_STATIC_LIBRARY_SUFFIX})

include_directories(${sfml_SOURCE_DIR}/include)
include_directories(${CMAKE_CURRENT_LIST_DIR})

set(SRCS
    ${CMAKE_CURRENT_LIST_DIR}/main.cpp
)

add_executable(inochi2d
    ${SRCS}
)

file(GLOB LIBS "${CMAKE_CURRENT_LIST_DIR}/.build/*${CMAKE_STATIC_LIBRARY_SUFFIX}")

target_link_libraries(inochi2d
    PRIVATE
        libinochi2d
        ${LIBS}
        libphobos
        libdruntime
        sfml-audio
        sfml-graphics
        sfml-system
        sfml-window
)

target_compile_features(inochi2d PRIVATE cxx_std_14)

install(TARGETS inochi2d)

