//
//  CharacterBadgeView.swift
//  Challenge1
//
//  Created by Nathan Ubeda on 10/9/24.
//

import SwiftUI

/// Displays a VStack containing an image, a title and a description.
struct CharacterBadgeView: View {
	let character: Character
	
    var body: some View {
		VStack {
			HStack(alignment: .top, spacing: 10) {
				AsyncImage(url: URL(string: character.thumbnail.url)) { image in
					image
						.resizable()
						.frame(maxWidth: 100, maxHeight: 100)
						.clipShape(RoundedRectangle(cornerRadius: 10))
				} placeholder: {
					ProgressView()
				}
				
				self.characterNameAndDescription
			}
		}
		.padding(10)
		.background(Color(#colorLiteral(red: 0.8745453954, green: 0.8745453954, blue: 0.8745453954, alpha: 1)))
		.clipShape(RoundedRectangle(cornerRadius: 10))
		.frame(maxWidth: 280, minHeight: 120)
    }
	
	/// Displays a VStack with texts for the name and description of the character.
	private var characterNameAndDescription: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(character.name)
				.font(.title)
				.fontWeight(.medium)
				.lineLimit(1)
			
			Text(character.description.isEmpty ? "No description available." : character.description)
				.foregroundStyle(.secondary)
				.lineLimit(4)
		}
	}
}

#Preview {
	VStack {
		CharacterBadgeView(
			character: .spidermanRed
		)
		
		CharacterBadgeView(
			character: .spidermanBlack
		)
		
		CharacterBadgeView(
			character: .venom
		)
	}
}
