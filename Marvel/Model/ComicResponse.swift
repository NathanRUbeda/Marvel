//
//  ComicResponse.swift
//  Marvel
//
//  Created by Nathan Ubeda on 12/1/24.
//

import Foundation

/// An object that represents an array of comics.
struct ComicResponse: Codable {
	/// Array of comics.
	let results: [Comic]
}
