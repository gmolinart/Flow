import Flow
import SwiftUI

func simplePatch() -> Patch {
    let generator = Node(name: "generator", color: "cyan", outputs: ["out"])
    let processor = Node(name: "processor", color: "red", inputs: ["in"], outputs: ["out"])
    let mixer = Node(name: "mixer", color: "gray", inputs: ["in1", "in2"], outputs: ["out"])
    let output = Node(name: "output", color: "purple", inputs: ["in"])

    let nodes = [generator, processor, generator, processor, mixer, output]

    let wires = Set([Wire(from: OutputID(0, 0), to: InputID(1, 0)),
                     Wire(from: OutputID(1, 0), to: InputID(4, 0)),
                     Wire(from: OutputID(2, 0), to: InputID(3, 0)),
                     Wire(from: OutputID(3, 0), to: InputID(4, 1)),
                     Wire(from: OutputID(4, 0), to: InputID(5, 0))])

    var patch = Patch(nodes: nodes, wires: wires)
    patch.recursiveLayout(nodeIndex: 5, at: CGPoint(x: 800, y: 50))
    return patch
}

/// Bit of a stress test to show how Flow performs with more nodes.
func randomPatch() -> Patch {
    var randomNodes: [Node] = []
    for n in 0 ..< 50 {
        let randomPoint = CGPoint(x: 1000 * Double.random(in: 0 ... 1),
                                  y: 1000 * Double.random(in: 0 ... 1))
        randomNodes.append(Entity(name: "node\(n)",
																	position: [randomPoint.x, randomPoint.y])
                                
    }

    var randomWires: Set<Wire> = []
    for n in 0 ..< 50 {
        randomWires.insert(Wire(from: OutputID(n, 0), to: InputID(Int.random(in: 0 ... 49), 0)))
    }
    return Patch(nodes: randomNodes, wires: randomWires)
}

struct ContentView: View {
    @State var patch = simplePatch()
    @State var selection = Set<NodeIndex>()

    func addNode() {
        let newNode = Node(name: "processor")
        patch.nodes.append(newNode)
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            NodeEditor(patch: $patch, selection: $selection)
            Button("Add Node", action: addNode).padding()
        }
    }
}


#Preview {
	ContentView()
	
}
