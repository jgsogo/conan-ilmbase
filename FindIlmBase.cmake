
set(ILMBASE_ROOT ${CONAN_ILMBASE_ROOT} CACHE PATH "Path to ILMBase root path")

find_path(ILMBASE_INCLUDE_DIRS
	NAMES IlmBaseConfig.h
	HINTS ${ILMBASE_ROOT}/include ${ILMBASE_ROOT}/include/OpenEXR
	DOC "The IlmBase include directory"
)


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(IlmBase
    REQUIRED_VARS
        ILMBASE_INCLUDE_DIRS
        ILMBASE_LIBRARIES
    VERSION_VAR
        ILMBASE_VERSION
)


find_package_handle_standard_args(IlmBase DEFAULT_MSG
    ILMBASE_INCLUDE_DIRS
    )
mark_as_advanced(ILMBASE_INCLUDE_DIRS)