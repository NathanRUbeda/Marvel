//
//  CharacterMocks.swift
//  MarvelAPIProject
//
//  Created by Nathan Ubeda on 10/15/24.
//

#if DEBUG
extension Character {
	static let venom: Character = .init(
		characterID: 1,
		name: "Venom",
		description: "",
		thumbnail: .init(
			path: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRFh7DN5UzzhhhKeefGusMSSaw_XsrkLzHOAg&s",
			extension: "jpg"
		)
	)
	
	static let spidermanRed: Character = .init(
		characterID: 1,
		name: "Spider-Man",
		description: "Your one and only friendly neighborhood Spider-Man.",
		thumbnail: .init(
			path: "https://static.wikia.nocookie.net/spideeey-database/images/5/58/Spooderman%28Far_From_Hoome_Suit%29.jpg/revision/latest?cb=20220114201224",
			extension: "jpg"
		)
	)
	
	static let spidermanBlack: Character = .init(
		characterID: 1,
		name: "Spider-Man (Miles Morales)",
		description: "",
		thumbnail: .init(
			path: "https://i.imgflip.com/8e35xh",
			extension: "jpg"
		)
	)
}
#endif
