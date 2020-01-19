project(SNANA C CXX Fortran)
cmake_minimum_required(VERSION 3.6)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
include(snana_macros)
check_libm_needed(LIBM_NEEDED)
if(LIBM_NEEDED)
    set(M_LIB "-lm")
endif()

find_package(cfitsio REQUIRED)


add_executable(fcasplit src/fcasplit.F)

set(WFIT_SRCS src/wfit.c src/sntools.c)
add_executable(wfit ${WFIT_SRCS})
target_link_libraries(wfit cfitsio::cfitsio ${M_LIB})
