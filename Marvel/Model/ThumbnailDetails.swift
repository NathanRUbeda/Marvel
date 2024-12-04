//
//  ThumbnailDetails.swift
//  Marvel
//
//  Created by Nathan Ubeda on 12/1/24.
//

import Foundation

/// An object that represents a thumbnail's URL.
struct ThumbnailDetails: Hashable, Codable {
	/// Path of the thumbnail's URL.
	let path: String
	
	/// Extension of the thumbnail's URL.
	let `extension`: String
	
	/// URL of the thumbnail.
	var url: String {
		"\(path).\(`extension`)"
	}
}
