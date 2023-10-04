// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import CoreGraphics
import Foundation

public extension Patch {
    /// Recursive layout.
    ///
    /// - Returns: Height of all nodes in subtree.
    @discardableResult
    mutating func recursiveLayout(
        nodeIndex: NodeIndex,
        at point: CGPoint,
        layout: LayoutConstants = LayoutConstants(),
        consumedNodeIndexes: Set<NodeIndex> = [],
        nodePadding: Bool = false
    ) -> (aggregateHeight: CGFloat,
          consumedNodeIndexes: Set<NodeIndex>)
    {
        nodes[nodeIndex].tx = Float(point.x)
        nodes[nodeIndex].ty = Float(point.y)
        nodes[nodeIndex].tz = 0


			let consumedNodeIndexes = consumedNodeIndexes

			let height: CGFloat = 0

        let nodeHeight = nodes[nodeIndex].rect(layout: layout).height
        let aggregateHeight = max(height, nodeHeight) + (nodePadding ? layout.nodeSpacing : 0)
        return (aggregateHeight: aggregateHeight,
                consumedNodeIndexes: consumedNodeIndexes)
    }

    /// Manual stacked grid layout.
    ///
    /// - Parameters:
    ///   - origin: Top-left origin coordinate.
    ///   - columns: Array of columns each comprised of an array of node indexes.
    ///   - layout: Layout constants.
    mutating func stackedLayout(at origin: CGPoint = .zero,
                                _ columns: [[NodeIndex]],
                                layout: LayoutConstants = LayoutConstants())
    {
        for column in columns.indices {
            let nodeStack = columns[column]
            var yOffset: CGFloat = 0

            let xPos = origin.x + (CGFloat(column) * (layout.nodeWidth + layout.nodeSpacing))
            for nodeIndex in nodeStack {
                nodes[nodeIndex].tx = Float(xPos)
								nodes[nodeIndex].ty =   Float(origin.y + yOffset)

                let nodeHeight = nodes[nodeIndex].rect(layout: layout).height
                yOffset += nodeHeight
                if column != columns.indices.last {
                    yOffset += layout.nodeSpacing
                }
            }
        }
    }
}
