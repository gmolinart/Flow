// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import SwiftUI

// View Modifiers

public extension NodeEditor {
    // MARK: - Event Handlers

    /// Called when a node is moved.
    func onNodeMoved(_ handler: @escaping NodeMovedHandler) -> Self {
        var viewCopy = self
        viewCopy.nodeMoved = handler
        return viewCopy
    }


    
    /// Called when the viewing transform has changed.
    func onTransformChanged(_ handler: @escaping TransformChangedHandler) -> Self {
        var viewCopy = self
        viewCopy.transformChanged = handler
        return viewCopy
    }

    // MARK: - Style Modifiers

    /// Set the node color.
    func nodeColor(_ color: Color) -> Self {
        var viewCopy = self
        viewCopy.style.nodeColor = color
        return viewCopy
    }


}
