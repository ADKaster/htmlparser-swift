set(SOURCES
    Assertions.cpp
    Base64.cpp
    ByteString.cpp
    ByteStringImpl.cpp
    CircularBuffer.cpp
    ConstrainedStream.cpp
    CountingStream.cpp
    Error.cpp
    FloatingPointStringConversions.cpp
    FlyString.cpp
    Format.cpp
    GenericLexer.cpp
    Hex.cpp
    JsonArray.cpp
    JsonObject.cpp
    JsonParser.cpp
    JsonValue.cpp
    MemoryStream.cpp
    NumberFormat.cpp
    OptionParser.cpp
    Random.cpp
    StackInfo.cpp
    Stream.cpp
    String.cpp
    StringBase.cpp
    StringBuilder.cpp
    StringFloatingPointConversions.cpp
    StringUtils.cpp
    StringView.cpp
    Time.cpp
    Utf16View.cpp
    Utf32View.cpp
    Utf8View.cpp
    kmalloc.cpp
)

if (WIN32)
    list(APPEND SOURCES LexicalPathWindows.cpp)
else()
    list(APPEND SOURCES LexicalPath.cpp)
endif()

configure_file(Debug.h.in Debug.h @ONLY)

serenity_lib(AK ak)

include(stacktrace)
configure_file(Backtrace.h.in Backtrace.h @ONLY)
link_stacktrace_library(AK STD_DEFINITION AK_HAS_STD_STACKTRACE)

target_link_libraries(AK PRIVATE simdutf::simdutf)

if (ENABLE_SWIFT)
    generate_clang_module_map(AK
       GENERATED_FILES
        "${CMAKE_CURRENT_BINARY_DIR}/Backtrace.h"
        "${CMAKE_CURRENT_BINARY_DIR}/Debug.h"
    )
    target_sources(AK PRIVATE AK+Swift.swift)
    add_swift_target_properties(AK)
endif()

if (WIN32)
    # FIXME: Windows on ARM
    target_link_libraries(AK PRIVATE clang_rt.builtins-x86_64.lib)
    target_link_libraries(AK PRIVATE Bcrypt.lib)
elseif (APPLE)
    set(ASSERTION_HANDLER_VISIBILITY PRIVATE)
    if (NOT BUILD_SHARED_LIBS)
        set(ASSERTION_HANDLER_VISIBILITY INTERFACE)
    endif()
    target_link_options(AK ${ASSERTION_HANDLER_VISIBILITY} LINKER:-U,_ak_assertion_handler)
endif()

