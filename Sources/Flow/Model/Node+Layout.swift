
import CoreGraphics
import Foundation

public extension Entity {
    /// Calculates the bounding rectangle for a node.
    func rect(layout: LayoutConstants) -> CGRect {
        let maxio = CGFloat(max(inputs.count, outputs.count))
        let size = CGSize(width: layout.nodeWidth,
                          height: CGFloat((maxio * (layout.portSize.height + layout.portSpacing)) + layout.nodeTitleHeight + layout.portSpacing))
        
        return CGRect(origin: CGPoint(x: CGFloat(self.tx), y: CGFloat(self.ty)), size:size)
    }

    /// Calculates the bounding rectangle for an input port (not including the name).
    func inputRect( layout: LayoutConstants) -> CGRect {
        let y = layout.nodeTitleHeight + CGFloat(0) * (layout.portSize.height + layout.portSpacing) + layout.portSpacing
        return CGRect(origin: CGPoint(x: CGFloat(self.tx) + layout.portSpacing, y: CGFloat(self.ty) + y),
                      size: layout.portSize)
    }

    /// Calculates the bounding rectangle for an output port (not including the name).
    func outputRect( layout: LayoutConstants) -> CGRect {
        let y = layout.nodeTitleHeight + CGFloat(0) * (layout.portSize.height + layout.portSpacing) + layout.portSpacing
        return CGRect(origin: CGPoint(x: CGFloat(self.tx) + layout.nodeWidth - layout.portSpacing - layout.portSize.width, y: CGFloat(self.ty) + y),
                      size: layout.portSize)
    }
}
