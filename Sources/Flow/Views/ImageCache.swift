//
//  File.swift
//  
//
//  Created by Guillermo Molina on 10/9/23.
//

import Foundation
import SwiftUI
import Foundation
import SwiftUI

extension Image: Hashable {
    public func hash(into hasher: inout Hasher) {
        // Implement a custom hashing logic for the Image type
        // For example, you can hash the description of the image
//        hasher.combine(self.description)
    }
}

struct ImageCache: Equatable ,Hashable{
    var string: String
		var image: Image
    
//    func hash(into hasher: inout Hasher) {
//        hasher.combine(string)
//    }
	
    
    public func hash(into hasher: inout Hasher) {
        // Implementation for hashing an Image instance
        // Implementation for hashing an Image instance
			hasher.combine(string)
			hasher.combine(image)
		
    }
}
