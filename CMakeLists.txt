cmake_minimum_required(VERSION 4.0.2)
project(SOJ ASM_MASM)

find_program(UASM_EXECUTABLE
        NAMES uasm32 uasm
        PATHS "${CMAKE_SOURCE_DIR}/uasm257_x86"
        "/msys64/mingw64/bin"
)

if (NOT UASM_EXECUTABLE)
    message(FATAL_ERROR "uasm32 not found. Please ensure it is in your system's PATH or located in ${CMAKE_SOURCE_DIR}/uasm257_x86/")
endif ()
set(CMAKE_ASM_MASM_COMPILER ${UASM_EXECUTABLE})

find_program(LLD_LINK_EXECUTABLE lld-link
        PATHS "C:/Program Files (x86)/LLVM/bin"
)

if (NOT LLD_LINK_EXECUTABLE)
    message(FATAL_ERROR "lld-link not found. Please ensure it is in your system's PATH or located in C:/Program Files (x86)/LLVM/bin")
endif ()

set(CMAKE_ASM_MASM_FLAGS "-Zi8 -Fl -Sa -coff")

set(CMAKE_ASM_MASM_LINK_EXECUTABLE "\"${LLD_LINK_EXECUTABLE}\" <LINK_FLAGS> <OBJECTS> /OUT:<TARGET> <LINK_LIBRARIES>")

set(CMAKE_EXE_LINKER_FLAGS "/DEBUG /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /SAFESEH:NO")

set(IRVINE_DIR ${CMAKE_SOURCE_DIR}/Irvine32)
include_directories(${IRVINE_DIR})

set(LIBS
        ${IRVINE_DIR}/Irvine32.lib
        ${IRVINE_DIR}/Kernel32.lib
        ${IRVINE_DIR}/User32.lib
)

add_subdirectory(src)
