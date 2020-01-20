project(SNANA C CXX Fortran)
cmake_minimum_required(VERSION 3.10)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
list(APPEND CMAKE_PREFIX_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
include(snana_macros)
check_libm_needed(LIBM_NEEDED)
if(LIBM_NEEDED)
    set(M_LIB "-lm")
endif()

find_package(cfitsio REQUIRED)
find_package(gsl REQUIRED)

option(ENABLE_ROOT "enable the use of ROOT output" ON)

if(ENABLE_ROOT)
    find_package(ROOT)
    if(NOT ${ROOT_FOUND})
        message(FATAL_ERROR "asked to enable ROOT support, but ROOT was not found by cmake")
    endif()
endif()

#find minicern lib
list(GET ROOT_LIBRARIES 1 A_ROOT_LIB)
get_filename_component(ROOT_LIBROOT ${A_ROOT_LIB} DIRECTORY)
message(STATUS "root lib dir :${ROOT_LIBROOT}")
find_library(minicern_LIBRARY minicern PATHS ${ROOT_LIBROOT})
message("minicern library: ${minicern_LIBRARY}")

add_executable(fcasplit src/fcasplit.F) 
add_library(minuit src/minuit.F)


set(genmag_srcs src/genmag_stretch2.c src/genmag_mlcs2k2.c
                src/genmag_SALT2.c src/genmag_snoopy.c
                src/genmag_S11DM15.c src/genmag_SIMSED.c
                src/genmag_SEDtools.c src/genmag_NON1AGRID.c
                src/genmag_NON1AGRID.c src/genmag_LCLIB.c
                src/genmag_BYOSED.c)
add_library(snana_genmag ${genmag_srcs})
target_link_libraries(snana_genmag gsl::gsl gsl::gslcblas cfitsio::cfitsio)


set(sntools_srcs src/sntools.c src/sntools_fitsio.c src/sntools_fluxErrModels.c 
                 src/sntools_genGauss_asym.c src/sntools_genSmear.c
                 src/sntools_gridgen.c src/sntools_host.c 
                 src/sntools_kcor.c src/sntools_nearnbr.c
                 src/sntools_nonlinearity.c 
                 src/sntools_spectrograph.c
                 src/sntools_trigger.c src/sntools_weaklens.c src/sntools_stronglens.c src/sntools_wronghost.c)

add_library(snana_sntools ${sntools_srcs})
target_link_libraries(snana_sntools gsl::gsl gsl::gslcblas cfitsio::cfitsio)

add_library(sntools_object OBJECT src/sntools.c src/sntools.h src/sndata.h)

#NOTE: to force compiling with c++ compiler when ROOT enabled
if(ENABLE_ROOT)
    configure_file(src/sntools_output.c ${CMAKE_CURRENT_BINARY_DIR}/sntools_output.cpp COPYONLY)
    add_library(sntools_output_object OBJECT ${CMAKE_CURRENT_BINARY_DIR}/sntools_output.cpp)
    target_include_directories(sntools_output_object PRIVATE ${ROOT_INCLUDE_DIRS} ${CMAKE_CURRENT_SOURCE_DIR}/src)
else()
    add_library(sntools_output_object OBJECT src/sntools_output.c)
endif()



add_executable(sntable_dump src/sntable_dump.c $<TARGET_OBJECTS:sntools_output_object> $<TARGET_OBJECTS:sntools_object>)
if(ENABLE_ROOT)
    target_link_libraries(sntable_dump ${ROOT_LIBRARIES} ${minicern_LIBRARY})
endif()
target_link_libraries(sntable_dump gsl::gsl gsl::gslcblas)




# set(WFIT_SRCS src/wfit.c)
# add_executable(wfit src/wfit.c)
# target_link_libraries(wfit cfitsio::cfitsio gsl::gsl gsl::gslcblas ${M_LIB})

# add_executable(sncosmo_mcmc src/sncosmo_mcmc.c src/sntools_output.c)
# target_link_libraries(sncosmo_mcmc $<TARGET_OBJECTS:sntools_object> gsl::gsl gsl::gslcblas ${M_LIB})
