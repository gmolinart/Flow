// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import SwiftUI

/// Draws and interacts with the patch.
///
/// Draws everything using a single Canvas with manual layout. We found this is faster than
/// using a View for each Node.
public struct NodeEditor: View {
    /// Data model.
    @Binding var patch: Patch

    /// Selected nodes.
    @Binding var selection: Set<NodeIndex>

    /// State for all gestures.
    @GestureState var dragInfo = DragInfo.none
    
    /// Node moved handler closure.
    public typealias NodeMovedHandler = (_ index: NodeIndex,
                                         _ location: CGPoint) -> Void
    
    /// Called when a node is moved.
    var nodeMoved: NodeMovedHandler = { (_,_) in }

    /// Wire added handler closure.
    public typealias WireAddedHandler = (_ wire: Wire) -> Void
    
    /// Called when a wire is added.
    var wireAdded: WireAddedHandler = { _ in }
    
    /// Wire removed handler closure.
    public typealias WireRemovedHandler = (_ wire: Wire) -> Void
    
    /// Called when a wire is removed.
    var wireRemoved: WireRemovedHandler = { _ in }

    /// Initialize the patch view with a patch and a selection.
    ///
    /// To define event handlers, chain their view modifiers: ``onNodeMoved(_:)``, ``onWireAdded(_:)``, ``onWireRemoved(_:)``.
    ///
    /// - Parameters:
    ///   - patch: Patch to display.
    ///   - selection: Set of nodes currently selected.
    public init(patch: Binding<Patch>,
                selection: Binding<Set<NodeIndex>>) {
        _patch = patch
        _selection = selection
    }

    /// Constants used for layout.
    var layout = LayoutConstants()
    
    /// Configuration used to determine rendering style.
    public var style = Style()

    @State var pan: CGSize = .zero
    @State var zoom: Double = 1
    
    public var body: some View {
        ZStack {
            Canvas { cx, size in

                let viewport = CGRect(origin: toLocal(.zero), size: toLocal(size))
                cx.addFilter(.shadow(radius: 5))

                cx.scaleBy(x: CGFloat(zoom), y: CGFloat(zoom))
                cx.translateBy(x: pan.width, y: pan.height)

                drawWires(cx: cx, viewport: viewport)
                drawNodes(cx: cx, viewport: viewport)
                drawDraggedWire(cx: cx)
                drawSelectionRect(cx: cx)

            }
            WorkspaceView(pan: $pan, zoom: $zoom)
                .gesture(dragGesture)
        }

    }
}
