
add_executable(TestHTMLParser
    TestHTMLTokenizerSwift.swift
)

# FIXME: Swift doesn't seem to like object libraries for @main
target_sources(TestHTMLParser PRIVATE ../Resources/SwiftTestMain.swift)

set_target_properties(TestHTMLParser PROPERTIES SUFFIX .swift-testing)
target_link_libraries(TestHTMLParser PRIVATE AK HtmlParser SwiftTesting::SwiftTesting)
add_test(NAME TestHTMLParser COMMAND TestHTMLParser)
