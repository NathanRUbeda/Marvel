//
//  MarvelCharacterProvider.swift
//  MarvelAPIProject
//
//  Created by Nathan Ubeda on 10/15/24.
//

import ComposableArchitecturePattern
import CryptoKit
import Foundation

/// An object that interacts with a cloud service.
actor MarvelCharacterProvider: CharacterProvidable {
	static let currentEnvironment = ServerEnvironment.production(url: "https://gateway.marvel.com:443/v1/public")
	static let supportedEnvironments = [currentEnvironment]
	
	static let characterAPI = MarvelCharacterAPI(
		environment: currentEnvironment,
		headers: nil,
		queries: [
			.init(name: "orderBy", value: "name"),
			.init(name: "limit", value: "100"),
		]
	)
	
	static let comicsAPI = MarvelComicAPI(
		environment: currentEnvironment,
		headers: nil,
		queries: [
			.init(name: "orderBy", value: "title"),
			.init(name: "limit", value: "100")
		]
	)
	
	lazy var server = MarvelServer(
		environments: Self.supportedEnvironments,
		currentEnvironment: Self.currentEnvironment,
		supportedAPIs: [
			Self.characterAPI,
			Self.comicsAPI
		]
	)
	
	var characterAPIOffset = 0
	var totalCharacterOffset = 0
	var requestNumber = 0
	
	/// Fetches a character based on a searched name.
	/// - Parameters:
	/// - name: The name of the character.
	/// - Returns: A `MarvelAPIResponse` object.
	/// - Throws: A `NetworkError` if encountered during processing of request.
	func fetchSearchedCharacters(name: String) async throws -> MarvelAPIResponse {
		var additionalQueryItems = try self._additionalQueryItems()
		additionalQueryItems?.append(.init(name: "nameStartsWith", value: name))
		
		print("server APIs: \(await self.server.apis)")
		print("character API: \(Self.characterAPI)")
		
		let response: MarvelAPIResponse = try await self.server.get(
			using: Self.characterAPI,
			queries: additionalQueryItems
		)
		
		return response
	}
	
	/// Fetches characters.
	/// - Parameters:
	/// - shouldIncrementCharacterOffset: checks if character offset should be incremented 
	/// - Returns: A `MarvelAPIResponse` object.
	/// - Throws: A `NetworkError` if encountered during processing of request.
	func fetchCharacters(shouldIncrementCharacterOffset: Bool = true) async throws -> MarvelAPIResponse {
		if self.characterAPIOffset > 0, self.characterAPIOffset == self.totalCharacterOffset {
			throw ServerError.totalReached
		}
		
		var additionalQueryItems = try self._additionalQueryItems()
		if shouldIncrementCharacterOffset {
			additionalQueryItems?.append(.init(name: "offset", value: String(self.characterAPIOffset)))
		}
		let response: MarvelAPIResponse = try await self.server.get(
			using: Self.characterAPI,
			queries: additionalQueryItems
		)
		self.totalCharacterOffset = response.data.total
		if shouldIncrementCharacterOffset {
			let remainingOffset = response.data.total -	 self.characterAPIOffset
			let nextOffset = remainingOffset > 100 ? 100 : remainingOffset
			self.characterAPIOffset += nextOffset
			self.requestNumber += 1
			print("request \(self.requestNumber)")
			print("character offset: \(self.characterAPIOffset)")
		}
		
		return response
	}
	
	/// Fetches a character based on its name.
	/// - Parameters:
	/// - name: The name of the character.
	/// - Returns: A `Character` object.
	/// - Throws: A `NetworkError` if encountered during processing of request.
	func fetchCharacterDetail(name: String) async throws -> Character {
		let additionalQueryItems = try self._additionalQueryItems()
		let character: Character = try await self.server.get(
			using: Self.characterAPI,
			queries: additionalQueryItems
		)
		return character
	}
	
	/// Creates additional query items.
	/// - Returns: An optional `URLQueryItem` array.
	/// - Throws: A `NetworkError` if encountered during processing of request.
	private func _additionalQueryItems() throws -> [URLQueryItem]? {
		guard let privateKey = ProcessInfo.processInfo.environment["API_Secret_Key"], let publicKey = ProcessInfo.processInfo.environment["API_Public_Key"] else {
			throw ServerAPIError.badRequest(description: "Must have private and public keys available in the environment. Check your shizzle.", error: nil)
		}
		let ts = String(Date().timeIntervalSince1970)
		let hash = MD5(
			data: "\(ts)\(privateKey)\(publicKey)"
		)
		
		let additionalQueries: [URLQueryItem]? = {
			var additionalQueries = [URLQueryItem]()
			additionalQueries.append(contentsOf: [
				.init(name: "apikey", value: publicKey),
				.init(name: "ts", value: ts),
				.init(name: "hash", value: hash)
			])
			return additionalQueries
		}()
		
		return additionalQueries
	}
	
	/// Creates a MD5 hash out of data.
	/// - Parameters:
	/// - data: A input string used to create a MD5 hash.
	/// - Returns: A `String` object.
	func MD5(data: String) -> String {
		let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
		return hash.map {
			String(format: "%02hhx", $0)
		}
		.joined()
	}
}

extension Sequence where Element == Decodable.Type {
	/// Whether the given collection of decodable types is equal to this collection of decodable types.
	func isEqual(to other: [Decodable.Type]) -> Bool {
		self.contains(where: { type in other.contains(where: { $0 == type }) })
	}
}
