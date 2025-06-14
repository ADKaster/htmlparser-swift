/*
 * Copyright (c) 2025, Andrew Kaster <andrew@ladybird.org>
 *
 * SPDX-License-Identifier: BSD-2-Clause
 */

import Collections
import Foundation

struct SpeculativeMockElement {
    let name: Swift.String
    let localName: Swift.String
    let attributes: [HTMLToken.Attribute]
    var children: [SpeculativeMockElement]

    init(name: Swift.String, localName: Swift.String, attributes: [HTMLToken.Attribute]) {
        self.name = name
        self.localName = localName
        self.attributes = attributes
        self.children = []
    }

    mutating func appendChild(_ child: consuming SpeculativeMockElement) {
        children.append(child)
    }
}

public final class SpeculativeHTMLParser {

}
