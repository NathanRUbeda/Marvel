//
//  Character.swift
//  MarvelAPIProject
//
//  Created by Nathan Ubeda on 10/15/24.
//

import SwiftUI
import Foundation

/// An object that represents a character.
struct Character: Identifiable, Hashable, Codable {
	/// ID of the object.
	let id = UUID()
	
	/// ID of the character.
	let characterID: Int
	
	/// Name of the character.
	let name: String
	
	/// Description of the character.
	let description: String
	
	/// Thumbnail of the character.
	let thumbnail: ThumbnailDetails
	
	enum CodingKeys: String, CodingKey {
		case characterID = "id"
		case name
		case description
		case thumbnail
	}
}



