# These are the minimal set of sources needed to build the code generators. We separate them to allow
# LibCore to depend on generated sources.
set(SOURCES
    ArgsParser.cpp
    Directory.cpp
    DirectoryEntry.cpp
    DirIterator.cpp
    Environment.cpp
    File.cpp
    StandardPaths.cpp
    Version.cpp
)

if (WIN32)
    list(APPEND SOURCES
        ProcessWindows.cpp
        SocketpairWindows.cpp
        SystemWindows.cpp)
else()
    list(APPEND SOURCES
        Process.cpp
        System.cpp)
endif()

serenity_lib(LibCoreMinimal coreminimal)
target_link_libraries(LibCoreMinimal PRIVATE AK)

if (${CMAKE_SYSTEM_NAME} MATCHES "NetBSD")
    # NetBSD has its shm_open and shm_unlink functions in librt so we need to link that
    target_link_libraries(LibCoreMinimal PRIVATE rt)
endif()
