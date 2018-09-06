PROJECT(PackageTest)
cmake_minimum_required(VERSION 2.8)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
CONAN_BASIC_SETUP()

find_package(IlmBase REQUIRED)

message(STATUS "IlmBase libraries: ${ILMBASE_LIBRARIES}")
message(STATUS "IlmBase include dirs: ${ILMBASE_INCLUDE_DIRS}")

ADD_EXECUTABLE(testPackage main.cpp testMatrix.cpp)
#include_directories(${CMAKE_CURRENT_SOURCE_DIR} ${ILMBASE_INCLUDE_DIRS})
TARGET_LINK_LIBRARIES(testPackage IlmBase)

get_target_property(OUT testPackage LINK_LIBRARIES)
message(STATUS ${OUT})

