cmake_minimum_required(VERSION 3.25)

project(full_indiction)

find_program(LUA_54_EXE lua5.4 REQUIRED)

add_custom_command(
  OUTPUT full_indiction.h full_indiction.cpp
  COMMAND ${LUA_54_EXE} ${CMAKE_CURRENT_SOURCE_DIR}/gen_src.lua full_indiction.h full_indiction.cpp
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/gen_src.lua
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  VERBATIM
)

add_library(${PROJECT_NAME} STATIC
  ${CMAKE_CURRENT_BINARY_DIR}/full_indiction.h
  ${CMAKE_CURRENT_BINARY_DIR}/full_indiction.cpp
)

target_compile_options(${PROJECT_NAME} PRIVATE $<$<CXX_COMPILER_ID:GNU>:-fconstexpr-ops-limit=3355443300>)

target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_23)

target_include_directories(${PROJECT_NAME}
  PUBLIC
      $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
)
