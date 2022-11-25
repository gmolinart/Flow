// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import CoreGraphics
import SwiftUI

/// Define the layout geometry of the nodes.
public struct LayoutConstants {
    let portSize = CGSize(width: 20, height: 20)
    let portSpacing: CGFloat = 10
    let nodeWidth: CGFloat = 200
    let nodeTitleHeight: CGFloat = 40
    let nodeSpacing: CGFloat = 40
    let nodeTitleFont = Font.title
    let portNameFont = Font.caption

    public init() {}
}
