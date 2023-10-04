// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import SwiftUI

public extension NodeEditor {
    /// Offset to apply to a node based on selection and gesture state.
    func offset(for idx: NodeIndex) -> CGSize {
        if patch.nodes[idx].locked {
            return .zero
        }
        switch dragInfo {
        case let .node(index: index, offset: offset):
            if idx == index {
                return offset
            }
            if selection.contains(index), selection.contains(idx) {
                // Offset other selected node only if we're dragging the
                // selection.
                return offset
            }
        default:
            return .zero
        }
        return .zero
    }



    /// Search for a node which intersects a point.
    func findNode(point: CGPoint) -> NodeIndex? {
        // Search nodes in reverse to find nodes drawn on top first.
        patch.nodes.enumerated().reversed().first { _, node in
            node.rect(layout: layout).contains(point)
        }?.0
    }
}
