set(SOURCES
    Entities.cpp
    HTMLTokenizerHelpers.cpp
    HTMLToken.swift
    HTMLTokenizer.swift
    SpeculativeHTMLParser.swift
)

function (generate_html_implementation)
    set(INPUT_FOLDER "${CMAKE_CURRENT_SOURCE_DIR}")

    invoke_generator(
        "NamedCharacterReferences.cpp"
        GenerateNamedCharacterReferences
        "${INPUT_FOLDER}/Entities.json"
        "NamedCharacterReferences.h"
        "NamedCharacterReferences.cpp"
        arguments -j "${INPUT_FOLDER}/Entities.json"
    )

    set(HTML_GENERATED_HEADERS
       "NamedCharacterReferences.h"
    )
    list(TRANSFORM HTML_GENERATED_HEADERS PREPEND "${CMAKE_CURRENT_BINARY_DIR}/")
    set(HTML_GENERATED_HEADERS ${HTML_GENERATED_HEADERS} PARENT_SCOPE)
endfunction()

generate_html_implementation()

set(GENERATED_SOURCES NamedCharacterReferences.cpp)

serenity_lib(HtmlParser htmlparser)
target_link_libraries(HtmlParser PRIVATE AK LibCoreMinimal Collections)
target_include_directories(HtmlParser PRIVATE ${CMAKE_CURRENT_SOURCE_DIR} ${CMAKE_CURRENT_BINARY_DIR})

generate_clang_module_map(HtmlParser GENERATED_FILES "${HTML_GENERATED_HEADERS}")
add_swift_target_properties(HtmlParser LAGOM_LIBRARIES AK)
