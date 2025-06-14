cmake_minimum_required(VERSION 4.0)
project(HTMLParserSwift LANGUAGES C CXX Swift)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
set(CMAKE_CXX_SCAN_FOR_MODULES OFF)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

set(CMAKE_COLOR_DIAGNOSTICS ON)

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

set(ENABLE_SWIFT ON)

if (NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang$")
    message(FATAL_ERROR "This project requires Clang from swift.org or Xcode release.")
endif()

include(compile_options)
include(install_options)
include(swift-settings)
include(utils)

include(simdutf)
include(collections)

#add_swift_link_options("-static-stdlib")
add_cxx_compile_options("-Wno-unqualified-std-cast-call")
add_cxx_compile_options("-Wno-user-defined-literals")
add_cxx_compile_options("-Wno-unknown-warning-option")

include_directories(Sources)
include_directories(${CMAKE_CURRENT_BINARY_DIR}/Sources)

add_subdirectory(Sources/AK)
add_subdirectory(Sources/LibMain)
add_subdirectory(Sources/LibCore)

add_subdirectory(Sources/GenerateNamedCharacterReferences)
add_subdirectory(Sources/HtmlParser)

include(CTest)
if (BUILD_TESTING)
    add_subdirectory(Tests/HtmlParserTests)
endif()
