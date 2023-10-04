// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import SwiftUI

/// Draws and interacts with the patch.
///
/// Draws everything using a single Canvas with manual layout. We found this is faster than
/// using a View for each Node.
///
/// The `NodeEditor` is a SwiftUI view that is responsible for drawing and interacting with the patch.
///
/// It uses a single `Canvas` for drawing everything and manual layout for positioning the nodes. This approach was found to be faster than using a separate `View` for each `Node`.
///
/// The `NodeEditor` uses several properties and methods to manage the patch and its nodes:
///
/// - `patch`: The data model for the patch. It is a `Binding` to a `Patch` object.
/// - `selection`: A `Binding` to a `Set` of `NodeIndex` objects representing the currently selected nodes.
/// - `dragInfo`: A `GestureState` object that holds the state for all gestures.
/// - `textCache`: A `StateObject` that caches resolved text.
/// - `layer`: A `LayoutConstants` object that defines the layout of the nodes.
/// - `nodeMoved`: A closure that is called when a node is moved.
/// - `wireAdded`: A closure that is called when a wire is added.
/// - `wireRemoved`: A closure that is called when a wire is removed.
/// - `transformChanged`: A closure that is called when the patch is panned or zoomed.
///
/// The `NodeEditor` is initialized with a patch and a selection. Event handlers can be defined by chaining their view modifiers: `onNodeMoved(_:)`, `onWireAdded(_:)`, `onWireRemoved(_:)`.
///
/// The `NodeEditor` also contains several other properties for managing the layout and rendering style, as well as the pan, zoom, and mouse position.
///
/// The `body` of the `NodeEditor` is a `ZStack` that contains a `Canvas` for drawing the nodes and wires, and a `WorkspaceView` for handling gestures.
///
/// The `NodeEditor` also provides two utility functions for creating simple and random patches for testing purposes: `simplePatch()` and `randomPatch()`.
	
public struct NodeEditor: View {
    /// Data model.
    @Binding var patch: Patch

    /// Selected nodes.
    @Binding var selection: Set<NodeIndex>

    /// State for all gestures.
    @GestureState var dragInfo = DragInfo.none

    /// Cache resolved text
    @StateObject var textCache = TextCache()
	
//    @StateObject var imageCache = ImageCache()
	
		public var layer : LayoutConstants = LayoutConstants()
	 

	

    /// Node moved handler closure.
    public typealias NodeMovedHandler = (_ index: NodeIndex,
                                         _ location: CGPoint) -> Void

    /// Called when a node is moved.
    var nodeMoved: NodeMovedHandler = { _, _ in }

    
    /// Handler for pan or zoom.
    public typealias TransformChangedHandler = (_ pan: CGSize, _ zoom: CGFloat) -> Void
    
    /// Called when the patch is panned or zoomed.
    var transformChanged: TransformChangedHandler = { _, _ in }

    /// Initialize the patch view with a patch and a selection.
    ///
    /// To define event handlers, chain their view modifiers: ``onNodeMoved(_:)``, ``onWireAdded(_:)``, ``onWireRemoved(_:)``.
    ///
    /// - Parameters:
    ///   - patch: Patch to display.
    ///   - selection: Set of nodes currently selected.
    public init(patch: Binding<Patch>,
                selection: Binding<Set<NodeIndex>>,
                layout: LayoutConstants = LayoutConstants())
    {
        _patch = patch
        _selection = selection
        self.layout = layout
    }

    /// Constants used for layout.
    var layout: LayoutConstants

    /// Configuration used to determine rendering style.
    public var style = Style()

    @State var pan: CGSize = .zero
    @State var zoom: Double = 1
    @State var mousePosition: CGPoint = CGPoint(x: CGFloat.infinity, y: CGFloat.infinity)
	
	func drawNodes(cx: GraphicsContext, viewport: CGRect) {
		
		
		for (nodeIndex, node) in patch.nodes.enumerated() {
			drawNodeComponents( node: node,
													index: nodeIndex,
													cx: cx,
													viewport:viewport)
			
		}
	}
    public var body: some View {
        ZStack {
					
            Canvas { cx, size in
                // Remove canvas shadow
                cx.addFilter(.shadow(radius: 0))
            

                let viewport = CGRect(origin: toLocal(.zero), size: toLocal(size))
							
								
                // cx.addFilter(.shadow(radius: 5))
                
                cx.scaleBy(x: CGFloat(zoom), y: CGFloat(zoom))
                cx.translateBy(x: pan.width, y: pan.height)
							
                let gridSpacing: CGFloat = 80
                let gridWidth: CGFloat = 4
                let gridColor: Color = .black

								let xStart = Int((viewport.minX - 30 * gridSpacing) / gridSpacing ) * Int(gridSpacing)
                let xEnd = Int((viewport.maxX + gridSpacing) / gridSpacing) * Int(gridSpacing)

                let yStart = Int((viewport.minY - 30 * gridSpacing) / gridSpacing) * Int(gridSpacing)
                let yEnd = Int((viewport.maxY  + gridSpacing) / gridSpacing) * Int(gridSpacing)

                for x in stride(from: xStart, through: xEnd, by: Int(gridSpacing)) {
                    let line = Path { path in
                        path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(yStart)))
                        path.addLine(to: CGPoint(x: CGFloat(x), y: CGFloat(yEnd)))
                    }
                    cx.stroke(line, with: .color(gridColor), lineWidth: gridWidth)
                    
                }

                for y in stride(from: yStart, through: yEnd, by: Int(gridSpacing)) {
                    let line = Path { path in
                        path.move(to: CGPoint(x: CGFloat(xStart), y: CGFloat(y)))
                        path.addLine(to: CGPoint(x: CGFloat(xEnd), y: CGFloat(y)))
                    }
                    cx.stroke(line, with: .color(gridColor), lineWidth: gridWidth)
                }
                
//                self.drawWires(cx: cx, viewport: viewport)
                self.drawNodes(cx: cx, viewport: viewport)
//                self.drawDraggedWire(cx: cx)
//                self.drawSelectionRect(cx: cx)
            }
					
            WorkspaceView(pan: $pan, zoom: $zoom, mousePosition: $mousePosition)
                #if os(macOS)
                .gesture(commandGesture)
                .onAppear() {
                    print("macOS: commandGesture is active")
                }
                #endif
					#if os(iOS)
                .gesture(dragGesture)
					#endif
        }
        .onChange(of: pan) { newValue in
            transformChanged(newValue, zoom)
        }
        .onChange(of: zoom) { newValue in
            transformChanged(pan, newValue)
        }
    }
}




/// Bit of a stress test to show how Flow performs with more nodes.
//func randomPatch() -> Patch {
//    var randomNodes: [Entity] = []
//    for n in 0 ..< 50 {
//        let randomPoint = CGPoint(x: 1000 * Double.random(in: 0 ... 1),
//                                  y: 1000 * Double.random(in: 0 ... 1))
//			//Todo fix this
//			randomNodes.append(Entitinputs: ["In"], y(name: "node\(n)",: "out" :Entity(name"out")),]);)


//    var randomWires: Set<Wire> = []
//    for n in 0 ..< 50 {
//        randomWires.insert(Wire(from: OutputID(n, 0), to: InputID(Int.random(in: 0 ... 49), 0)))
//    }
//    return Patch(nodes: randomNodes, wires: randomWires)
//}
//
//struct ContentView: View {
//    @State var patch = simplePatch()
//    @State var selection = Set<NodeIndex>()
//
//    func addNode() {
//			let newNode = Entity(name: "processor", inputs: ["in": Entity(name:"")], outputs: ["out": Entity(name:"")])
//        patch.nodes.append(newNode)
//    }
//
//    var body: some View {
//        ZStack(alignment: .topTrailing) {
//            NodeEditor(patch: $patch, selection: $selection)
//            Button("Add Node", action: addNode).padding()
//        }
//    }
//}
//

//#Preview {
//	ContentView()
//	
//}
