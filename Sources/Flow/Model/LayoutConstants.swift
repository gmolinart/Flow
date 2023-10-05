// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/

import CoreGraphics
import SwiftUI



/// Define the layout geometry of the nodes.
public struct LayoutConstants {
    public var portSize = CGSize(width: 14, height: 14)
    public var portSpacing: CGFloat = 10
		public var portWidth = CGFloat(2)
    public var nodeWidth: CGFloat = 200
    public var nodeTitleHeight: CGFloat = 60
    public var nodeSpacing: CGFloat = 40
		public var nodeCornerRadius: CGFloat = 8
	
		public var input_offset =  CGSize(width: -20 , height: 0)
		public var output_offset = CGSize(width: 22 , height: 0)
	
		public var nodeTitleFont = Font.custom("JetBrainsMonoNL-Regular", size: 22.0)
    public var portNameFont = Font.custom("JetBrainsMonoNL-Regular", size: 16.0)

    public init() {}
}
