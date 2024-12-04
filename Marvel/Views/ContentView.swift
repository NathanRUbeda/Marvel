//
//  ContentView.swift
//  Challenge1
//
//  Created by Nathan Ubeda on 9/30/24.
//

import Combine
import SwiftUI

/// Displays a NavigationStack with a ScrollView for all the characters and a search bar.
struct ContentView: View {
	enum Actions {
		case getCharacters
		case getSearchedCharacters(name: String)
	}
	
	@DebouncedState(delay: 1.0) private var characterName = ""
	@State private var showSearch = true
	@State private var searchTaskID: UUID?
	@State private var visibleCharacterID: Character.ID?
	
	private var filteredCharacters: [Character] {
		guard !self.characterName.isEmpty else {
			return self.characters
		}
		
		return self.searchedCharacters
	}
	
	let marvelCharacterProvider: MarvelCharacterProvider
	let characters: [Character]
	let searchedCharacters: [Character]
	let isFetching: Bool
	let perform: (Actions) async throws -> Void
	let columns = [
		GridItem(.adaptive(minimum: 300, maximum: 350), spacing: 10)
	]
	
	var body: some View {
		NavigationStack {
			self.characterScrollView
				.padding()
				.overlay {
					if self.characters.isEmpty {
						ContentUnavailableView("No characters found.", systemImage: "exclamationmark.magnifyingglass", description: Text("Search for a character's name."))
					}
				}
				.navigationTitle("Marvel Comics!")
				.toolbar {
					ToolbarItem(placement: .navigation) {
						Image("logo")
							.resizable()
							.frame(width: 50, height: 50)
					}
					
					ToolbarItem(placement: .principal) {
						if self.isFetching {
							ProgressView()
								.controlSize(.small)
						}
					}
				}
				.searchable(
					text: self.$characterName,
					isPresented: self.$showSearch,
					prompt: "Search..."
				)
				.onChange(of: self.characterName) { oldValue, newValue in
					guard !self.characterName.isEmpty else {
						return
					}

					Task {
						do {
							try await self.perform(.getSearchedCharacters(name: characterName))
						} catch {
							print(error)
						}
					}
				}
		}
	}
	
	/// Displays a ScrollView of characters.
	private var characterScrollView: some View {
		ScrollViewReader { proxy in
			ScrollView {
				LazyVGrid(columns: self.columns) {
					ForEach(self.filteredCharacters) { character in
						NavigationLink {
							CharacterDetailView(character: character)
						} label: {
							CharacterBadgeView(character: character)
						}
						.buttonStyle(.plain)
					}
					.frame(minWidth: 250, maxWidth: .infinity, maxHeight: .infinity)
					.scrollContentBackground(.hidden)
				}
				.scrollTargetLayout()
			}
			.scrollPosition(
				id: self.$visibleCharacterID,
				anchor: .bottomTrailing
			)
			.onChange(of: self.visibleCharacterID) { oldValue, newValue in
				print("newValue: \(newValue)")
				let correspondingCharacter = self.characters.lazy.firstIndex(where: { $0.id == newValue })
				print("newValue's index: \(correspondingCharacter)")
				print("totalIndexes: \(self.characters.indices)")
				guard let lastCharacter = self.characters.lazy.last else {
					return
				}
				let lastIndex = self.characters.lastIndex(of: lastCharacter)
				print("lastIndex: \(lastIndex)")
				let shouldGetMoreCharacters: Bool
				
				if let lastIndex {
					let fiftyBeforeLast = self.characters.index(lastIndex, offsetBy: -50)
					if newValue == self.characters[fiftyBeforeLast].id {
						shouldGetMoreCharacters = true
					} else {
						shouldGetMoreCharacters = false
					}
				} else {
					shouldGetMoreCharacters = false
				}
				
				guard shouldGetMoreCharacters else {
					print("Not at the bottom just yet")
					return
				}
				print("User has reached the bottom.")
				
				Task {
					do {
						try await self.perform(.getCharacters)
					} catch {
						print(error)
					}
				}
			}
		}
	}
}

