//
//  MarvelAPIResponse.swift
//  Marvel
//
//  Created by Nathan Ubeda on 12/1/24.
//

import Foundation

/// An object that represents an API response.
struct MarvelAPIResponse: Codable {
	/// An object that represents a network response containing an array of characters.
	let data: CharacterResponse
}
