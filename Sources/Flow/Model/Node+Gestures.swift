

import CoreGraphics
import Foundation


extension Entity {
	public func translate(by offset: CGSize) -> Entity {
			var result = self
		result.tx += Float(offset.width)
		result.ty += Float(offset.height)
			return result
	}

		func hitTest(nodeIndex: Int, point: CGPoint, layout: LayoutConstants) -> Patch.HitTestResult? {
				for (inputIndex, _) in inputs.enumerated() {
						if inputRect(layout: layout).contains(point) {
								return .input(nodeIndex, inputIndex)
						}
				}
				for (outputIndex, _) in outputs.enumerated() {
						if outputRect(layout: layout).contains(point) {
								return .output(nodeIndex, outputIndex)
						}
				}

				if rect(layout: layout).contains(point) {
						return .node(nodeIndex)
				}

				return nil
		}
}
