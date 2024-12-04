//
//  MarvelApp.swift
//  Marvel
//
//  Created by Nathan Ubeda on 10/15/24.
//

import SwiftUI

@main
struct Marvel: App {
	let marvelCharacterProvider = MarvelCharacterProvider()
	var viewModel = CharacterViewModel()
	var searchViewModel = SearchedCharacterViewModel()
	
	@State var currentFetchUID: UUID?
	@State var characterSortComparator: Set<KeyPathComparator<Character>> = [.init(\.name)]
	
	init() {
		self._fetchInitialCharacters()
	}
	var body: some Scene {
		WindowGroup {
			ContentView(
				marvelCharacterProvider: marvelCharacterProvider,
				characters: self.viewModel.characters, searchedCharacters: self.searchViewModel.characters,
				isFetching: self.viewModel.isFetching,
				perform: { action in
					switch action {
						case .getCharacters:
							do {
								let characters = try await self._fetchCharacters()
								self.viewModel.characters.append(contentsOf: characters)
								self.viewModel.characters.sort(using: self.characterSortComparator)
							} catch let error as ServerError {
								if error != .totalReached {
									throw error
								}
							}
							
						case let .getSearchedCharacters(name):
							do {
								if !searchViewModel.characters.isEmpty {
									searchViewModel.characters.removeAll()
								}
								
								let characters = try await self._fetchSearchedCharacters(name: name)
								self.searchViewModel.characters.append(contentsOf: characters)
								self.searchViewModel.characters
									.sort(using: self.characterSortComparator)
							} catch let error as ServerError {
								throw error
							}
					}
				}
			)
		}
	}
	
	/// Fetches characters for initial view.
	private func _fetchInitialCharacters() {
		Task {
			do {
				let characters = try await self._fetchCharacters().sorted(using: self.characterSortComparator)
				self.viewModel.characters = characters
			} catch {
				print(error)
			}
		}
	}
	
	/// Fetches characters.
	/// - Parameters:
	/// - Returns: An array of `Character` objects.
	/// - Throws: A `NetworkError` if encountered during processing of request.
	private func _fetchCharacters() async throws -> [Character] {
		defer {
			self.viewModel.isFetching = false
		}
		self.viewModel.isFetching = true
		let response = try await self.marvelCharacterProvider.fetchCharacters()
		return response.data.results
	}
	
	/// Fetches a character based on a searched name.
	/// - Parameters:
	/// - name: The name of the character.
	/// - Returns: A `MarvelAPIResponse` object.
	/// - Throws: A `NetworkError` if encountered during processing of request.
	private func _fetchSearchedCharacters(name: String) async throws -> [Character] {
		defer {
			self.viewModel.isFetching = false
		}
		self.viewModel.isFetching = true
		let response = try await self.marvelCharacterProvider.fetchSearchedCharacters(name: name)
		return response.data.results
	}
}
