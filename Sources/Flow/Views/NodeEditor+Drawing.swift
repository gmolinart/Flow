import SwiftUI

extension Color {
		static let action = Color( red: 1, green: 0.853, blue: 0.182)
		static let selected = Color( red: 1, green: 0.483, blue: 0.382)
		static let transparent_select = Color( red: 1, green: 0.153, blue: 0.182, opacity: 0.1)
}

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
			 selectedColor: Color = Color.selected,
			 lineColor: Color = Color(red: 0, green: 0, blue: 0, opacity: 1),
			 unselectedColor: Color = Color.action) {
		
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
	
	
	func drawComponentHeader(rect: CGRect){
		var titleBar = Path()
		let cornerRadius : CGFloat = layout.nodeCornerRadius
		
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
	func drawNodeComponents(node:Entity, index : Int, cx: GraphicsContext , viewport:CGRect){
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
		
		
		cx.stroke(bg, with: .color(.black), style: .init(lineWidth: 5.0))
		
		//						cx.draw(image, at:node.position)
		
		
		if rect.contains(toLocal(mousePosition)) {
			cx.stroke(bg, with: .color(.white), style: .init(lineWidth: 4.0))
		}
		
		cx.draw(textCache.text(string:"🚀", font: title, cx),
						at: pos + CGSize(width: 18, height: layout.nodeTitleHeight / 2),
						anchor: .center)
		cx.draw(textCache.text(string: node.name, font: title, cx),
						at: pos + CGSize(width: rect.size.width / 2, height: layout.nodeTitleHeight / 2),
						anchor: .center)
		cx.draw(textCache.text(string: node.name, font: title, cx),
						at: pos + CGSize(width: rect.size.width / 2, height: layout.nodeTitleHeight / 2),
						anchor: .center)
		
		//		let in_offset : CGSize =   (offset + layout.input_offset)
		//		let out_offset :CGSize =  (offset + layout.output_offset)
		
		//		var input_color = [PortType: GraphicsContext.Shading]()
		//		var output_color = [PortType: GraphicsContext.Shading]()
		
		//		let connectedInputs = Set( patch.wires.map { wire in wire.input } )
		//		let connectedOutputs = Set( patch.wires.map { wire in wire.output} )
		
		//		for (i, input) in node.inputs.enumerated() {
		//			drawInputPort(
		//				cx: cx,
		//				node: node,
		//				index: i,
		//				offset: in_offset,
		//				width: layout.portWidth,
		//				portShading: input.value.color,
		//				isConnected: connectedInputs.contains(InputID(index, i))
		//			)
		//		}
		//		let inputKeys = Array(node.inputs.keys).sorted()
		//		for (i, key) in inputKeys.enumerated() {
		//			let input = node.inputs[key]
		//			drawInputPort(
		//				cx: cx,
		//				node: node,
		//				index: i,
		//				offset: in_offset,
		//				width: layout.portWidth,
		//				portShading: input!.color,
		//				isConnected: connectedInputs.contains(InputID(index, i))
		//			)
		//		}
		//	}
	}
	
	
		func drawSelectionRect(cx: GraphicsContext) {
			
			let main_color = cx.resolve(.color(Color.transparent_select))
			
			if case let .selection(rect: rect) = dragInfo {
				let rectPath = Path(roundedRect: rect, cornerRadius: 5)
				cx.fill(rectPath, with: main_color)
				cx.stroke(rectPath, with: .color(.black),lineWidth: 4)
			}
		}
		
	}
	
	
