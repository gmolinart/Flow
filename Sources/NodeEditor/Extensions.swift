import Foundation
import SwiftUI

extension String {
    func deletingPrefix(_ prefix: String) -> String? {
        guard self.hasPrefix(prefix) else { return nil }
        return String(self.dropFirst(prefix.count))
    }
}

extension CGSize {
    var point: CGPoint {
        CGPoint(x: width, y: height)
    }
}

func +(lhs: CGPoint, rhs: CGSize) -> CGPoint {
    CGPoint(x: lhs.x + rhs.width, y: lhs.y + rhs.height)
}

func -(lhs: CGPoint, rhs: CGPoint) -> CGSize {
    CGSize(width: lhs.x - rhs.x, height: lhs.y - rhs.y)
}

extension CGRect {
    var center: CGPoint {
        origin + CGSize(width: size.width/2, height: size.height/2)
    }
}

extension CGPoint {
    var size: CGSize {
        CGSize(width: x, height: y)
    }
}

extension Color {
    static let magenta = Color(.sRGB, red: 1, green: 0, blue: 1, opacity: 1)
}