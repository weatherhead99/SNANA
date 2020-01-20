macro(check_libm_needed VAR_LIBM_NEEDED)
    include(CheckFunctionExists)
    message("checking whether we need to link against libm...")
    check_function_exists(acos ACOS_FUNCTION_EXISTS)
    if(NOT ACOS_FUNCTION_EXISTS)
        message("...and we do!")
        list(APPEND CMAKE_REQUIRED_LIBRARIES m)
        set(${VAR_LIBM_NEEDED} TRUE CACHE BOOL "" FORCE)
    else()
        message("..and we don't!")
        set(${VAR_LIBM_NEEDED} FALSE CACHE BOOL "" FORCE)
    endif()

endmacro()


macro(run_ypatchy OUTFILE INFILE)
    set(ypatchy ${CMAKE_SOURCE_DIR}/util/ypatchy.pl)
    add_custom_command(OUTPUT ${OUTFILE}
    COMMAND ${ypatchy} - ${OUTFILE} ${INFILE} .go
    COMMENT "running ypatchy on ${INFILE} to generate ${OUTFILE}")
endmacro()
