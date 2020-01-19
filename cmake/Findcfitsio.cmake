include(FindPackageHandleStandardArgs)

find_path(FITSIO_H_DIR fitsio.h PATH_SUFFIXES cfitsio)

#TODO option to use pkg-config etc etc


mark_as_advanced(FITSIO_H_DIR CFITSIO_LIB)

set(CFITSIO_INCLUDE_DIRS "")
set(CFITSIO_LIBRARIES "")

if(FITSIO_H_DIR)
    list(APPEND CFITSIO_INCLUDE_DIRS ${FITSIO_H_DIR})
endif()


find_library(CFITSIO_LIB cfitsio)

if(CFITSIO_LIB)
    list(APPEND CFITSIO_LIBRARIES ${CFITSIO_LIB})
endif()



find_package_handle_standard_args(cfitsio FOUND_VAR CFITSIO_FOUND REQUIRED_VARS CFITSIO_LIBRARIES CFITSIO_INCLUDE_DIRS)


if(CFITSIO_FOUND AND NOT TARGET cfitsio::cfitsio)
    add_library(cfitsio::cfitsio UNKNOWN IMPORTED)
    set_target_properties(cfitsio::cfitsio PROPERTIES
        IMPORTED_LOCATION ${CFITSIO_LIB}
        INTERFACE_INCLUDE_DIRECTORIES ${FITSIO_H_DIR})
endif()
