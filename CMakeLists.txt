cmake_minimum_required(VERSION 4.1)
project(Sample_project ASM_MASM)

find_program(UASM_EXECUTABLE uasm32
        PATHS "${CMAKE_SOURCE_DIR}/uasm257_x86"
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

set(CMAKE_ASM_MASM_FLAGS "/Zi8 /Fl /Sa -coff ")

set(CMAKE_ASM_MASM_LINK_EXECUTABLE "\"${LLD_LINK_EXECUTABLE}\" <LINK_FLAGS> <OBJECTS> /OUT:<TARGET> <LINK_LIBRARIES>")

set(CMAKE_EXE_LINKER_FLAGS "/DEBUG /SUBSYSTEM:CONSOLE /MACHINE:X86 /ENTRY:main /SAFESEH:NO")


add_executable(Sample_project)
add_subdirectory(src)
set(IRVINE_DIR ${CMAKE_SOURCE_DIR}/Irvine32)
target_include_directories(Sample_project PRIVATE ${IRVINE_DIR})
target_link_libraries(Sample_project PRIVATE ${IRVINE_DIR}/Irvine32.lib
        PRIVATE ${IRVINE_DIR}/Kernel32.lib
        PRIVATE ${IRVINE_DIR}/User32.lib)