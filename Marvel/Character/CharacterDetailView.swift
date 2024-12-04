//
//  CharacterDetailView.swift
//  Challenge1
//
//  Created by Nathan Ubeda on 10/8/24.
//

import SwiftUI

/// Displays a VStack containing all the information about the character.
struct CharacterDetailView: View {
	let character: Character
	
	var body: some View {
		VStack {
			self.background
			
			AsyncImage(url: URL(string: character.thumbnail.url)) { image in
				image
					.resizable()
					.frame(width: 200, height: 200)
					.clipShape(RoundedRectangle(cornerRadius: 10))
					.shadow(radius: 7)
					.offset(y: -110)
					.padding(.bottom, -110)
				
			} placeholder: {
				ProgressView()
			}
			
			self.characterNameText
			
			self.characterDescriptionText
			
			Spacer()
		}
	}
	
	/// Displays a secondary-colored rectangle.
	private var background: some View {
		Rectangle()
			.fill(Color.secondary)
			.frame(maxWidth: .infinity)
			.frame(height: 200)
	}
	
	/// Displays a text with the name of the character.
	private var characterNameText: some View {
		Text(character.name)
			.font(.largeTitle)
			.fontWeight(.bold)
	}
	
	/// Displays a text with the description of the character.
	private var characterDescriptionText: some View {
		Text(
			character.description.isEmpty ? "No description available." : character.description
		)
	}
}

#Preview {
	CharacterDetailView(
		character: .venom
	)
}
