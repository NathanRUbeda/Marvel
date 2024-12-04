//
//  MockCharacterProvider.swift
//  MarvelTests
//
//  Created by Nathan Ubeda on 12/3/24.
//

import ComposableArchitecturePattern
import Foundation
@testable import Marvel

/// An object that mimics an interaction with a cloud service using a JSON file.
actor MockCharacterProvider: CharacterProvidable {
	func fetchSearchedCharacters(name: String) async throws -> MarvelAPIResponse {
		let url: URL? = switch name {
			case "hulk":
				Bundle(for: MockCharacterProvider.self).url(forResource: "mockHulkCharactersJSON", withExtension: "json")
			case "venom":
				Bundle(for: MockCharacterProvider.self).url(forResource: "mockVenomCharactersJSON", withExtension: "json")
			case "groot":
				Bundle(for: MockCharacterProvider.self).url(forResource: "mockGrootCharactersJSON", withExtension: "json")
			default:
				nil
		}
		
		guard let jsonURL = url else {
			throw ServerError.missingJSON
		}
		
		guard let data = try? Data(contentsOf: jsonURL) else {
			throw ServerError.loadingError
		}
		
		let decoder = JSONDecoder()
		return try decoder.decode(MarvelAPIResponse.self, from: data)
	}

	func fetchCharacters(shouldIncrementCharacterOffset: Bool) async throws -> MarvelAPIResponse {
		guard let jsonURL = Bundle(for: MockCharacterProvider.self).url(forResource: "mock10CharactersJSON", withExtension: "json") else {
			throw ServerError.missingJSON
		}
		
		guard let data = try? Data(contentsOf: jsonURL) else {
			throw ServerError.loadingError
		}
		
		let decoder = JSONDecoder()
		return try decoder.decode(MarvelAPIResponse.self, from: data)
	}
}
