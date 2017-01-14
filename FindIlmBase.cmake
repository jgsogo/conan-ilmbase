set(ILMBASE_INCLUDE_DIRS "${CONAN_INCLUDE_DIRS_ILMBASE}")
set(ILMBASE_LIBRARY_DIRS "${CONAN_LIB_DIRS_ILMBASE}")
set(ILMBASE_LIBRARIES    "${CONAN_LIBS_ILMBASE}")

set(ILMBASE_INCLUDE_DIR  "${ILMBASE_INCLUDE_DIRS}")
set(ILMBASE_LIBRARY_DIR  "${ILMBASE_LIB_DIRS}")
set(ILMBASE_LIBRARY      "${ILMBASE_LIBRARIES}")

foreach (LIBNAME ${ILMBASE_LIBRARIES})
    string(REGEX MATCH "[^-]+" LIBNAME_STEM ${LIBNAME})
    set(ILMBASE_${LIBNAME_STEM}_LIBRARY ${LIBNAME})
endforeach()

foreach (INCLUDE_DIR ${ILMBASE_INCLUDE_DIRS})
    if(NOT ILMBASE_VERSION AND INCLUDE_DIR AND EXISTS "${INCLUDE_DIR}/OpenEXR/IlmBaseConfig.h")
      file(STRINGS
           ${INCLUDE_DIR}/OpenEXR/IlmBaseConfig.h
           TMP
           REGEX "#define ILMBASE_VERSION_STRING.*$")
      string(REGEX MATCHALL "[0-9.]+" ILMBASE_VERSION ${TMP})
    endif()
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(IlmBase
    REQUIRED_VARS
        ILMBASE_INCLUDE_DIRS
        ILMBASE_LIBRARY_DIRS
        ILMBASE_LIBRARIES
    VERSION_VAR
        ILMBASE_VERSION
)
