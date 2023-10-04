import SwiftUI

struct NodeColor {
	/// A structure that defines the colors used in the node editor.
	///
	/// It contains shading for selected nodes, black color shading, and shading for unselected nodes.
	/// These shadings are resolved from the provided colors in the initializer.
	///
	/// - Parameters:
	///   - cx: The graphics context used to resolve the colors.
	///   - selectedColor: The color used for selected nodes. Defaults to a specific shade of yellow.
	///   - blackColor: The color used for black shading. Defaults to black.
	///   - unselectedColor: The color used for unselected nodes. Defaults to a specific shade of yellow.
	
	
	let selectedShading: GraphicsContext.Shading
	let line: GraphicsContext.Shading
	let unselectedShading: GraphicsContext.Shading
	
	init(cx: GraphicsContext,
			 selectedColor: Color = Color(red: 0.9765347838, green: 0.858735621, blue: 0.3380537629, opacity: 1),
			 lineColor: Color = Color(red: 0, green: 0, blue: 0, opacity: 1),
			 unselectedColor: Color = Color(red: 0.9765347838, green: 0.858735621, blue: 0.3380537629, opacity: 1)) {
		
		self.selectedShading = cx.resolve(.color(selectedColor))
		self.line = cx.resolve(.color(lineColor))
		self.unselectedShading = cx.resolve(.color(unselectedColor))
	}
}

extension GraphicsContext {
	@inlinable @inline(__always)
	func drawDot(in rect: CGRect, with shading: Shading) {
		let dot = Path(ellipseIn: rect.insetBy(dx: rect.size.width / 3, dy: rect.size.height / 3))
		fill(dot, with: shading)
	}
	
	
	
	func strokeWire(
		from: CGPoint,
		to: CGPoint,
		gradient: Gradient
		
	) {
		let d = 0.4 * abs(to.x - from.x)
		var path = Path()
		path.move(to: from)
		path.addCurve(
			to: to,
			control1: CGPoint(x: from.x + d, y: from.y),
			control2: CGPoint(x: to.x - d, y: to.y)
		)
		
		stroke(
			path,
			with: .linearGradient(gradient, startPoint: from, endPoint: to),
			style: StrokeStyle(lineWidth: 4.0, lineCap: .round)
		)
	}
}



extension NodeEditor {
	@inlinable @inline(__always)
	func color(for type: PortType, isOutput: Bool) -> Color {
		style.color(for: type, isOutput: isOutput) ?? .gray
	}
	
	func drawInputPort(
		cx: GraphicsContext,
		node: Node,
		index: Int,
		offset: CGSize,
		width: CGFloat,
		portShading: GraphicsContext.Shading,
		isConnected: Bool
	) {
		let rect = node.inputRect(input: index, layout: layout).offset(by: offset + CGSize(width: 20, height: 0))
		//			rect.offsetBy(dx: 0, dy: 0)
		
		let circle = Path(ellipseIn: rect)
		let port = node.inputs[index]
		
		let main_color = cx.resolve(.color(Color(red: 0.9765347838, green: 0.858735621, blue: 0.3380537629, opacity: 1)))
		
		cx.fill(circle, with: main_color)
		
		cx.stroke(circle, with: .color(.black), style: .init(lineWidth: width))
		
		
		if !isConnected {
			cx.drawDot(in: rect, with: .color(.black))
		} else if rect.contains(toLocal(mousePosition)) {
			cx.stroke(circle, with: .color(.white), style: .init(lineWidth: 2.0))
		}
		
		cx.draw(
			textCache.text(string: port.name, font: layout.portNameFont, cx),
			at: rect.center + CGSize(width: layout.portSize.width / 2 + layout.portSpacing , height: 0),
			anchor: .leading
		)
	}
	
	func drawOutputPort(
		cx: GraphicsContext,
		node: Node,
		index: Int,
		offset: CGSize,
		width: CGFloat,
		portShading: GraphicsContext.Shading,
		isConnected: Bool
	) {
		
		let rect = node.outputRect(output: index, layout: layout).offset(by: offset + CGSize(width: -20, height: 0))
		let circle = Path(ellipseIn: rect)
		let port = node.outputs[index]
		
		
		
		let main_color = cx.resolve(.color(Color(red: 0.9765347838, green: 0.858735621, blue: 0.3380537629, opacity: 1)))
		
		cx.fill(circle, with: main_color)
		
		cx.stroke(circle, with: .color(.black), style: .init(lineWidth: width))
		if !isConnected {
			cx.drawDot(in: rect, with: .color(.black))
		}
		
		if rect.contains(toLocal(mousePosition)) {
			cx.stroke(circle, with: .color(.white), style: .init(lineWidth: 1.0))
		}
		
		cx.draw(textCache.text(string: port.name, font: layout.portNameFont, cx),
						at: rect.center + CGSize(width: -(layout.portSize.width / 2 + layout.portSpacing ), height: 0),
						anchor: .trailing)
	}
	
	func inputShading(_ type: PortType,  _ colors: inout [PortType: GraphicsContext.Shading], _ cx: GraphicsContext) -> GraphicsContext.Shading {
		if let shading = colors[type] {
			return shading
		}
		let shading = cx.resolve(.color(color(for: type, isOutput: false)))
		colors[type] = shading
		return shading
	}
	
	func outputShading(_ type: PortType,  _ colors: inout [PortType: GraphicsContext.Shading], _ cx: GraphicsContext) -> GraphicsContext.Shading {
		if let shading = colors[type] {
			return shading
		}
		let shading = cx.resolve(.color(color(for: type, isOutput: true)))
		colors[type] = shading
		return shading
	}
	func drawComponentHeader(rect: CGRect){
		var titleBar = Path()
		var cornerRadius : CGFloat = layout.nodeCornerRadius
		
		titleBar.move(to: CGPoint(x: 0, y: layout.nodeTitleHeight) + rect.origin.size)
		titleBar.addLine(to: CGPoint(x: 0, y: cornerRadius) + rect.origin.size)
		titleBar.addRelativeArc(center: CGPoint(x: cornerRadius, y: cornerRadius) + rect.origin.size,
														radius: cornerRadius,
														startAngle: .degrees(180),
														delta: .degrees(90))
		titleBar.addLine(to: CGPoint(x: layout.nodeWidth - cornerRadius, y: 0) + rect.origin.size)
		titleBar.addRelativeArc(center: CGPoint(x: layout.nodeWidth - cornerRadius, y: cornerRadius) + rect.origin.size,
														radius: cornerRadius,
														startAngle: .degrees(270),
														delta: .degrees(90))
		titleBar.addLine(to: CGPoint(x: layout.nodeWidth, y: layout.nodeTitleHeight) + rect.origin.size)
		titleBar.closeSubpath()
		
		//            cx.fill(titleBar, with: .color(node.titleBarColor))
	}
	func drawNodeComponents(node:Node, entity:Entity, index : Int, cx: GraphicsContext , viewport:CGRect){
		let offset = self.offset(for: index)
		let rect = node.rect(layout: layout).offset(by: offset)
		let rectShadow = rect.offset(by: CGSize(width: -10, height: 10))
		let cornerRadius : CGFloat  = layout.nodeCornerRadius
		let title = layout.nodeTitleFont
		guard rect.intersects(viewport) else { return  }
		
		let pos = rect.origin
		let bg = Path(roundedRect: rect, cornerRadius: cornerRadius)
		let shadow  = Path(roundedRect: rectShadow, cornerRadius: cornerRadius)
		let nodeColor = NodeColor(cx:cx)
		
		
		var selected = false
		switch dragInfo {
		case let .selection(rect: selectionRect):
			selected = rect.intersects(selectionRect)
		default:
			selected = selection.contains(index)
		}
		
		
		cx.fill(shadow, with : nodeColor.line)
		cx.fill(bg, with: selected ? nodeColor.selectedShading : nodeColor.unselectedShading)
		
		drawComponentHeader(rect: rect)
		
		
		cx.stroke(bg, with: selected ? .color(.white): .color(.black), style: .init(lineWidth: 5.0))
		
		//						cx.draw(image, at:node.position)
		
		
		if rect.contains(toLocal(mousePosition)) {
			cx.stroke(bg, with: .color(.white), style: .init(lineWidth: 4.0))
		}
		
//		cx.draw(textCache.text(string:"🚀", font: title, cx),
//						at: pos + CGSize(width: 18, height: layout.nodeTitleHeight / 2 * CGFloat(entity.ty)),
//						anchor: .center)
		
		cx.draw(textCache.text(string: entity.name, font: title, cx),
						at: pos + CGSize(width: rect.size.width / 2, height: layout.nodeTitleHeight / 2 * CGFloat(entity.ty) ),
						anchor: .center)
		
		let in_offset : CGSize =   (offset + layout.input_offset)
		let out_offset :CGSize =  (offset + layout.output_offset)
		
		var input_color = [PortType: GraphicsContext.Shading]()
		var output_color = [PortType: GraphicsContext.Shading]()
		
		let connectedInputs = Set( patch.wires.map { wire in wire.input } )
		let connectedOutputs = Set( patch.wires.map { wire in wire.output} )
		
		for (i, input) in node.inputs.enumerated() {
			drawInputPort(
				cx: cx,
				node: node,
				index: i,
				offset: in_offset,
				width: layout.portWidth,
				portShading: inputShading(input.type, &input_color, cx),
				isConnected: connectedInputs.contains(InputID(index, i))
			)
		}
		for (i, output) in node.outputs.enumerated() {
			drawOutputPort(
				cx: cx,
				node: node,
				index: i,
				offset: out_offset,
				width: layout.portWidth,
				portShading: outputShading(output.type, &output_color, cx),
				isConnected: connectedOutputs.contains(OutputID(index, i))
			)
		}
	}
func drawNodes(cx: GraphicsContext, viewport: CGRect) {
	
	for (nodeIndex, node) in patch.nodes.enumerated() {
		var inputs = [String: Entity]()
		for input in node.inputs {
			inputs[input.name] = Entity(name: input.name)
		}
		var outputs = [String: Entity]()
		for output in node.outputs {
			outputs[output.name] = Entity(name: output.name)
		}

		var entity = Entity(name : node.name, inputs:inputs, outputs:outputs)
		
		entity.ty = 1
		
		drawNodeComponents( node: node,
							entity:entity, 
							index: nodeIndex,
							cx: cx,
								viewport:viewport)
		
	}
}

	func drawGrid(cx:GraphicsContext, viewport: CGRect){
	
		let gridSpacing: CGFloat = 40
		let gridWidth: CGFloat = 2
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
	 
	}
func drawWires(cx: GraphicsContext, viewport: CGRect) {
	var hideWire: Wire?
	switch dragInfo {
	case let .wire(_, _, hideWire: hw):
		hideWire = hw
	default:
		hideWire = nil
	}
	for wire in patch.wires where wire != hideWire {
		let fromPoint = self.patch.nodes[wire.output.nodeIndex].outputRect(
			output: wire.output.portIndex,
			layout: self.layout
		)
			.offset(by: self.offset(for: wire.output.nodeIndex)).center
		
		let toPoint = self.patch.nodes[wire.input.nodeIndex].inputRect(
			input: wire.input.portIndex,
			layout: self.layout
		)
			.offset(by: self.offset(for: wire.input.nodeIndex)).center
		
		let bounds = CGRect(origin: fromPoint, size: toPoint - fromPoint)
		if viewport.intersects(bounds) {
			let gradient = self.gradient(for: wire)
			cx.strokeWire(from: fromPoint, to: toPoint, gradient: gradient)
		}
	}
}

func drawDraggedWire(cx: GraphicsContext) {
	if case let .wire(output: output, offset: offset, _) = dragInfo {
		let outputRect = self.patch
			.nodes[output.nodeIndex]
			.outputRect(output: output.portIndex, layout: self.layout)
		let gradient = self.gradient(for: output)
		cx.strokeWire(from: (outputRect.center ), to: outputRect.center + offset, gradient: gradient)
	}
}

func drawSelectionRect(cx: GraphicsContext) {
	
	let main_color = cx.resolve(.color(Color(red: 0.9765347838, green: 0.858735621, blue: 0.3380537629, opacity: 0.4)))
	if case let .selection(rect: rect) = dragInfo {
		let rectPath = Path(roundedRect: rect, cornerRadius: 5)
		cx.fill(rectPath, with: main_color)
		cx.stroke(rectPath, with: .color(.black),lineWidth: 4)
	}
}

func gradient(for outputID: OutputID) -> Gradient {
	let portType = patch
		.nodes[outputID.nodeIndex]
		.outputs[outputID.portIndex]
		.type
	return style.gradient(for: portType) ?? .init(colors: [.gray])
}

func gradient(for wire: Wire) -> Gradient {
	gradient(for: wire.output)
}
}
