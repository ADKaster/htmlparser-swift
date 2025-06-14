#
# Gets simdutf library from github
#

include(FetchContent)

set(SIMDUTF_TESTS OFF)
set(SIMDUTF_BENCHMARKS OFF)
set(SIMDUTF_TOOLS OFF)
set(SIMDUTF_CXX_STANDARD ${CMAKE_CXX_STANDARD})

FetchContent_Declare(
    simdutf
    GIT_REPOSITORY https://github.com/simdutf/simdutf.git
    GIT_TAG        v7.3.0
    PATCH_COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_LIST_DIR}/patches/git-patch.cmake"
                  "${CMAKE_CURRENT_LIST_DIR}/patches/simdutf/0001-CMake-Guard-shell-based-tests-with-SIMDUTF_TESTS.patch"
    OVERRIDE_FIND_PACKAGE
)
FetchContent_MakeAvailable(simdutf)

swizzle_target_properties_for_swift(simdutf)
