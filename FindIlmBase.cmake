
set(ILMBASE_ROOT ${CONAN_ILMBASE_ROOT} CACHE PATH "Path to ILMBase root path")

# Find include dirs
find_path(ILMBASE_INCLUDE_DIRS
	NAMES IlmBaseConfig.h
	HINTS ${ILMBASE_ROOT}/include ${ILMBASE_ROOT}/include/OpenEXR
)

# Look for libraries
foreach(LIBNAME Half Iex IexMath IlmThread Imath)
	find_library(ILMBASE_${LIBNAME}_LIBRARY
		NAMES ${LIBNAME}
        HINTS ${ILMBASE_ROOT}/lib
        PATH_SUFFIXES lib
        )
endforeach()

# Check version
file(STRINGS ${ILMBASE_INCLUDE_DIRS}/IlmBaseConfig.h TMP REGEX "#define ILMBASE_VERSION_STRING.*$")
string(REGEX MATCHALL "[0-9.]+" ILMBASE_VERSION ${TMP})

# handle the QUIETLY and REQUIRED arguments and set xxx_FOUND to TRUE
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(IlmBase
    REQUIRED_VARS
        ILMBASE_INCLUDE_DIRS
        ILMBASE_Half_LIBRARY
        ILMBASE_Iex_LIBRARY
        ILMBASE_IexMath_LIBRARY
        ILMBASE_IlmThread_LIBRARY
        ILMBASE_Imath_LIBRARY
    VERSION_VAR
        ILMBASE_VERSION
)

# Create imported targets
if(ILMBASE_FOUND)
    message(STATUS ">>>>>>")
    message(STATUS "ILMBASE_Half_LIBRARY: ${ILMBASE_Half_LIBRARY}")
    message(STATUS "INTERFACE_INCLUDE_DIRECTORIES: ${ILMBASE_INCLUDE_DIRS}")

    add_library(Half UNKNOWN IMPORTED)
    set_target_properties(Half PROPERTIES
        IMPORTED_LOCATION ${ILMBASE_Half_LIBRARY}
        INTERFACE_INCLUDE_DIRECTORIES ${ILMBASE_INCLUDE_DIRS}
        )

    add_library(Iex UNKNOWN IMPORTED)
    set_target_properties(Iex PROPERTIES
        IMPORTED_LOCATION ${ILMBASE_Iex_LIBRARY}
        INTERFACE_INCLUDE_DIRECTORIES ${ILMBASE_INCLUDE_DIRS}
        )

    add_library(IexMath UNKNOWN IMPORTED)
    set_target_properties(IexMath PROPERTIES
        IMPORTED_LOCATION ${ILMBASE_IexMath_LIBRARY}
        INTERFACE_INCLUDE_DIRECTORIES ${ILMBASE_INCLUDE_DIRS}
        IMPORTED_LINK_INTERFACE_LIBRARIES ${ILMBASE_Iex_LIBRARY}
        )

    add_library(IlmThread UNKNOWN IMPORTED)
    set_target_properties(IlmThread PROPERTIES
        IMPORTED_LOCATION ${ILMBASE_IlmThread_LIBRARY}
        INTERFACE_INCLUDE_DIRECTORIES ${ILMBASE_INCLUDE_DIRS}
        IMPORTED_LINK_INTERFACE_LIBRARIES ${ILMBASE_Iex_LIBRARY}
        )

    add_library(Imath UNKNOWN IMPORTED)
    set_target_properties(Imath PROPERTIES
        IMPORTED_LOCATION ${ILMBASE_Imath_LIBRARY}
        INTERFACE_INCLUDE_DIRECTORIES ${ILMBASE_INCLUDE_DIRS}
        IMPORTED_LINK_INTERFACE_LIBRARIES ${ILMBASE_Iex_LIBRARY}
        )

    add_library(IlmBase UNKNOWN IMPORTED)
    set_target_properties(IlmBase PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${ILMBASE_INCLUDE_DIRS}
        IMPORTED_LINK_INTERFACE_LIBRARIES ${ILMBASE_IexMath_LIBRARY}
                                          ${ILMBASE_IlmThread_LIBRARY}
                                          ${ILMBASE_Imath_LIBRARY}
        )

    set(${ILMBASE_LIBRARIES} IlmBase)
endif()


mark_as_advanced(MYPACKAGE_LIBRARY
    ILMBASE_Half_LIBRARY
    ILMBASE_Iex_LIBRARY
    ILMBASE_IexMath_LIBRARY
    ILMBASE_IlmThread_LIBRARY
    ILMBASE_Imath_LIBRARY)

if(MYPACKAGE_FOUND)
	mark_as_advanced(ILMBASE_ROOT)
endif()
