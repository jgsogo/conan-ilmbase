project(PackageTest)
cmake_minimum_required(VERSION 2.8)

include(${CMAKE_BINARY_DIR}/conanbuildinfo.cmake)
conan_basic_setup()

find_package(PkgConfig)
# TODO: Conan!! With the approach 2 we need to define 'package_root_path_ilmbase' variable.
set( ENV{PKG_CONFIG_PATH} "$ENV{PKG_CONFIG_PATH}:${CONAN_ILMBASE_ROOT}/lib/pkgconfig" )
pkg_check_modules(ILMBASE REQUIRED IlmBase)

message(STATUS "IlmBase libraries: ${ILMBASE_LIBRARIES}")
message(STATUS "IlmBase include dirs: ${ILMBASE_INCLUDE_DIRS}")

add_executable(testPackage main.cpp testMatrix.cpp)
target_link_libraries(testPackage ${ILMBASE_LIBRARIES})
