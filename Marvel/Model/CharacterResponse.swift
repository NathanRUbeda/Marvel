//
//  CharacterResponse.swift
//  Marvel
//
//  Created by Nathan Ubeda on 12/1/24.
//

import Foundation

// TODO: add documentation.

/// An object that represents a network response containing an array of characters.
struct CharacterResponse: Codable {
	/// The requested offset of the call.
	let offset: Int
	
	/// The requested result limit.
	let limit: Int
	
	/// Total of characters.
	let total: Int
	
	/// Total number of results.
	let count: Int
	
	/// Array of characters.
	let results: [Character]
}
