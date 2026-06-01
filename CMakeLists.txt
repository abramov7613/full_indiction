cmake_minimum_required(VERSION 3.25)

project(full_indiction)
option(NOTEST "" OFF)

find_program(LUA_EXECUTABLE NAMES lua5.4 lua54 lua5.5 lua55 lua REQUIRED)
add_custom_command(
  OUTPUT full_indiction.h full_indiction.cpp
  COMMAND ${LUA_EXECUTABLE} ${CMAKE_CURRENT_SOURCE_DIR}/gen_src.lua full_indiction.h full_indiction.cpp
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/gen_src.lua
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  VERBATIM
)
add_library(${PROJECT_NAME} STATIC
  ${CMAKE_CURRENT_BINARY_DIR}/full_indiction.h
  ${CMAKE_CURRENT_BINARY_DIR}/full_indiction.cpp
)
target_compile_options(${PROJECT_NAME} PRIVATE
  $<$<CXX_COMPILER_ID:GNU>:-fconstexpr-ops-limit=3355443300>
  $<$<CXX_COMPILER_ID:Clang>:-fbracket-depth=2048>
)
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)
target_include_directories(${PROJECT_NAME} PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)

if(NOT NOTEST)
  enable_testing()
  file(DOWNLOAD
    "https://github.com/catchorg/Catch2/releases/download/v3.14.0/catch_amalgamated.cpp"
    ${CMAKE_CURRENT_BINARY_DIR}/catch_amalgamated.cpp
    EXPECTED_HASH SHA256=d0b1a1c129bdac83cd358fa158186f5fec0128bb79a01a9a772322cd0dda1b13
  )
  file(DOWNLOAD
    "https://github.com/catchorg/Catch2/releases/download/v3.14.0/catch_amalgamated.hpp"
    ${CMAKE_CURRENT_BINARY_DIR}/catch_amalgamated.hpp
    EXPECTED_HASH SHA256=0393e18c86d62bf29c11a5329d8054285fe59516a59ac02df20b9dadf3a63566
  )
  add_library(Catch2 SHARED
    ${CMAKE_CURRENT_BINARY_DIR}/catch_amalgamated.cpp
    ${CMAKE_CURRENT_BINARY_DIR}/catch_amalgamated.hpp
  )
  target_compile_features(Catch2 PRIVATE cxx_std_23)
  target_include_directories(Catch2 PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>)
  add_executable(test01
    ${CMAKE_CURRENT_SOURCE_DIR}/test/test01.cpp
  )
  target_compile_features(test01 PRIVATE cxx_std_23)
  target_link_libraries(test01 PRIVATE ${PROJECT_NAME} Catch2)
  add_test(NAME T01 COMMAND test01)
endif()
