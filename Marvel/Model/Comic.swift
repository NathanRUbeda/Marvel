//
//  Comic.swift
//  MarvelAPIProject
//
//  Created by Nathan Ubeda on 10/15/24.
//

/// An object that represents a comic book.
struct Comic: Codable {
	/// ID of the comic book.
	let id: Int
	
	/// Title of the comic book.
	let title: String
	
	/// Description of the comic book.
	let description: String
	
	/// Total amount of pages in the comic book.
	let pageCount: Int
}
