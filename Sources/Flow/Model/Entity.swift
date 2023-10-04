// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/Flow/
/// Nodes are identified by index in `Patch/nodes``.
///
//public typealias NodeIndex = Int

import CoreGraphics
import SwiftUI
import Foundation

public struct Entity: Equatable {
	public static func == (lhs: Entity, rhs: Entity) -> Bool {
		return lhs.id == rhs.id
	}
	
	public var id: UUID
	public var name: String
	public var type: String?
	public var description: String?
	public var icon: String?
	public var image: String?
	public var comments: String?
	public var entities: [String: Entity]
	public var inputs: [String: Entity]
	public var outputs: [String: Entity]
	
	public var message: (() -> Void)?
	public var keywords: [String: String]
	public var tx: Float
	public var ty: Float
	public var tz: Float
	public var rx: Float
	public var ry: Float
	public var rz: Float
	public var sx: Float
	public var sy: Float
	public var sz: Float
	public var color: String
	public var locked = false
	
	public init(name: String,
							type: String? = "entity",
							color: String = "main",
							description: String? = nil,
							icon: String? = nil,
							image: String? = nil,
							comments: String? = nil,
							entities: [String: Entity] = [:],
							inputs: [String: Entity] = [:],
							outputs: [String: Entity] = [:],
							message: (() -> Void)? = nil,
							keywords: [String: String] = [:],
							position: [Float] = [0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0],
							locked: Bool = false)
	{
		self.id = UUID()
		self.name = name
		self.type = type
		self.description = description
		self.icon = icon
		self.image = image
		self.comments = comments
		self.entities = entities
		self.inputs = inputs
		self.outputs = outputs
		 self.message = message
		self.keywords = keywords
		self.tx = position.indices.contains(0) ? position[0] : 0.0
		self.ty = position.indices.contains(1) ? position[1] : 0.0
		self.tz = position.indices.contains(2) ? position[2] : 0.0
		self.rx = position.indices.contains(3) ? position[3] : 0.0
		self.ry = position.indices.contains(4) ? position[4] : 0.0
		self.rz = position.indices.contains(5) ? position[5] : 0.0
		self.sx = position.indices.contains(6) ? position[6] : 1.0
		self.sy = position.indices.contains(7) ? position[7] : 1.0
		self.sz = position.indices.contains(8) ? position[8] : 1.0
		self.color = color
		self.locked = locked
	}
	public func get_color() -> Color {
		switch self.color{
		case "main":
			return Color(#colorLiteral(red: 1, green: 0.8533880115, blue: 0.1825449467, alpha: 1))
		case "in":
			return Color(#colorLiteral(red: 0.9299485683, green: 0.3541637063, blue: 0.6539798379, alpha: 1))
		case "out":
			return Color(#colorLiteral(red: 0.5891749859, green: 0.4719975591, blue: 0.9838040471, alpha: 1))
		default:
			return Color.red
		}
	}
	public mutating func addEntity(_ entity: Entity) {
		self.entities[entity.name] = entity
	}
	
	public func getEntity(name: String, type: String? = nil) -> Entity? {
		guard let entity = self.entities[name] else {
			return nil
		}
		if let type = type, entity.type != type {
			return nil
		}
		return entity
	}
	
	func get_emoji(type: String) -> String {
		let emojiMap = [
			"char": "👤",
			"prop": "📦",
			"env": "🌳",
			"lib": "📚",
			"task": "📝",
			"shot": "🎥",
			"sequence": "🎬",
			"operator": "🛠️",
			"version": "⬆️"
		]
		return emojiMap[type, default: "🧬"]
	}
}
