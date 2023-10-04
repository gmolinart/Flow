import SwiftUI
struct Node {
    var position: CGPoint
}

struct Patch {
    var nodes: [Node]

    mutating func moveNode(nodeIndex: Int, offset: CGSize) {
        nodes[nodeIndex].position.x += offset.width
        nodes[nodeIndex].position.y += offset.height
    }
}

extension NodeEditor {
    @ObservedObject var patch: Patch

    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0)
        .updating($dragInfo) { drag, dragInfo, _ in
            let startLocation = toLocal(drag.startLocation)
            let location = toLocal(drag.location)
            let translation = toLocal(drag.translation)
            
            let hitResult = patch.hitTest(point: startLocation, layout: layout)
            
            switch hitResult {
            case let .node(nodeIndex):
                patch.moveNode(nodeIndex: nodeIndex, offset: translation)
            default:
                break
            }
        }
    }
}

	extension DragGesture.Value {
		@inlinable @inline(__always)
		var distance: CGFloat {
			startLocation.distance(to: location)
		}
	}

extension NodeEditor {
	/// State for all gestures.
	enum DragInfo {
		//		case wire(output: OutputID, offset: CGSize = .zero, hideWire: Wire? = nil)
		case node(index: NodeIndex, offset: CGSize = .zero)
		case selection(rect: CGRect = .zero)
		case none
	}
	
	
	func toLocal(_ p: CGPoint) -> CGPoint {
		CGPoint(x: p.x / CGFloat(zoom), y: p.y / CGFloat(zoom)) - pan
	}
	
	func toLocal(_ sz: CGSize) -> CGSize {
		CGSize(width: sz.width / CGFloat(zoom), height: sz.height / CGFloat(zoom))
	}
	
#if os(macOS)
	var commandGesture: some Gesture {
		DragGesture(minimumDistance: 0).modifiers(.command).onEnded { drag in
			// ...
			switch hitResult {
			case let .node(nodeIndex):
				print("Node with index: \(nodeIndex) has been clicked") // Print statement added here
				selection.insert(nodeIndex)
			default:
				break
			}
		}
	}
#endif
	
	var dragGesture: some Gesture {
		DragGesture(minimumDistance: 0)
        .updating($dragInfo) { drag, dragInfo, _ in
            let startLocation = toLocal(drag.startLocation)
            let location = toLocal(drag.location)
            let translation = toLocal(drag.translation)
            
            let hitResult = patch.hitTest(point: startLocation, layout: layout)
            
            switch hitResult {
            case let .node(nodeIndex):
                print("Node with index: \(nodeIndex) has been clicked") // Print statement added here
                dragInfo = .node(index: nodeIndex, offset: translation)
            default:
                dragInfo = .selection(rect: CGRect(a: startLocation, b: location))
            }
        }
			.onEnded { drag in
             let startLocation = toLocal(drag.startLocation)
            let location = toLocal(drag.location)
            let translation = toLocal(drag.translation)
            
            let hitResult = patch.hitTest(point: startLocation, layout: layout)

				switch hitResult {
				case let .node(nodeIndex):
					print("Node with index: \(nodeIndex) has been clicked") // Print statement added here
					// ...
				default: break
					
					let startLocation = toLocal(drag.startLocation)
					let location = toLocal(drag.location)
					let translation = toLocal(drag.translation)
					
					let hitResult = patch.hitTest(point: startLocation, layout: layout)
					
					// Note that this threshold should be in screen coordinates.
					if drag.distance > 5 {
						switch hitResult {
						case .none:
							let selectionRect = CGRect(a: startLocation, b: location)
							selection = self.patch.selected(
								in: selectionRect,
								layout: layout
							)
						case let .node(nodeIndex):
							patch.moveNode(
								nodeIndex: nodeIndex,
								offset: translation,
								nodeMoved: self.nodeMoved
							)
							if selection.contains(nodeIndex) {
								for idx in selection where idx != nodeIndex {
									patch.moveNode(
										nodeIndex: idx,
										offset: translation,
										nodeMoved: self.nodeMoved
									)
								}
							}
						default:
							break }
					}
					else {
						// If we haven't moved far, then this is effectively a tap.
						switch hitResult {
						case .none:
							selection = Set<NodeIndex>()
						case let .node(nodeIndex):
							selection.insert(nodeIndex)
							
						default: break
						}
					}
				}
				
			}
	}
}
