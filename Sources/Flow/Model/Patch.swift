// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import CoreGraphics
import Foundation

/// Data model for Flow.type command
///
/// Write a function to generate a `Patch` from your own data model
/// as well as a function to update your data model when the `Patch` changes.
/// Use SwiftUI's `onChange(of:)` to monitor changes, or use `NodeEditor.onNodeAdded`, etc.
public struct Patch: Equatable {
	public static func == (lhs: Patch, rhs: Patch) -> Bool {
	true
	}
	
    public var nodes: [Entity]
//    public var wires: Set<Wire>

    public init(nodes: [Entity] = [] ) {
        self.nodes = nodes
//        self.wires = wires
    }
    
}
