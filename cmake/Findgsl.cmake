include(FindPackageHandleStandardArgs)

mark_as_advanced(GSL_INC GSL_LIB GSLCBLAS_LIB)

if(NOT GSL_USE_CBLAS)
    set(GSL_USE_CBLAS TRUE CACHE BOOL "use the gsl cblas library")
endif()


find_path(GSL_INC gsl_version.h PATH_SUFFIXES gsl)

if(GSL_INC)
    list(APPEND GSL_INCLUDE_DIRS ${GSL_INC})
endif()

find_library(GSL_LIB gsl)

if(GSL_LIB)
    list(APPEND GSL_LIBRARIES ${GSL_LIB})
endif()

find_library(GSLCBLAS_LIB gslcblas)

if(GSLCBLAS_LIB)
    list(APPEND GSL_LIBRARIES ${GSLCBLAS_LIB})
endif()

find_package_handle_standard_args(gsl FOUND_VAR GSL_FOUND REQUIRED_VARS GSL_LIBRARIES GSL_INCLUDE_DIRS)

if(GSL_FOUND AND NOT TARGET gsl::gsl)
    add_library(gsl::gsl UNKNOWN IMPORTED)
    set_target_properties(gsl::gsl PROPERTIES 
                    IMPORTED_LOCATION ${GSL_LIB}
                    INTERFACE_INCLUDE_DIRECTORIES ${GSL_INCLUDE_DIRS})
    add_library(gsl::gslcblas UNKNOWN IMPORTED)
    set_target_properties(gsl::gslcblas PROPERTIES
                    IMPORTED_LOCATION ${GSLCBLAS_LIB}
                    INTERFACE_INCLUDE_DIRECTORIES ${GSL_INCLUDE_DIRS})
endif() 
