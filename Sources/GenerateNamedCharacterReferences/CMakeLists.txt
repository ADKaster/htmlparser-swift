add_executable(GenerateNamedCharacterReferences
    GenerateNamedCharacterReferences.cpp
)
target_link_libraries(GenerateNamedCharacterReferences PRIVATE
    AK
    LibCoreMinimal
    LibMain
)
target_include_directories(GenerateNamedCharacterReferences PRIVATE ${CMAKE_CURRENT_LIST_DIR})
