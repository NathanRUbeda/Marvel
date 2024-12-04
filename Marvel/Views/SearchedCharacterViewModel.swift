//
//  SearchedCharacterViewModel.swift
//  Marvel
//
//  Created by Nathan Ubeda on 12/1/24.
//

import Foundation

/// An object that is used to model data with home view.
@Observable
class SearchedCharacterViewModel {
	/// Checks if viewModel is done fetching or not.
	var isFetching = false
	
	/// Array of characters.
	var characters: [Character]
	
	init(characters: [Character] = []) {
		self.characters = characters
	}
}
