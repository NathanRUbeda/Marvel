//
//  CharacterProvidable.swift
//  Marvel
//
//  Created by Nathan Ubeda on 12/1/24.
//

import Foundation

/// An object that provides characters.
protocol CharacterProvidable {
	/// Sends request to get characters.
	/// - Parameters:
	/// - shouldIncrementCharacterOffset:
	/// - Returns: A `MarvelAPIResponse` object.
	/// - Throws: A `ServerError` if unable to build request or encountered during processing of request.
	func fetchCharacters(shouldIncrementCharacterOffset: Bool) async throws -> MarvelAPIResponse
	
	/// Fetches a character based on a searched name.
	/// - Parameters:
	/// - name: The name of the character.
	/// - Returns: A `MarvelAPIResponse` object.
	/// - Throws: A `NetworkError` if encountered during processing of request.
	func fetchSearchedCharacters(name: String) async throws -> MarvelAPIResponse
}
