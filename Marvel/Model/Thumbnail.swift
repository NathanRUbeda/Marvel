//
//  Thumbnail.swift
//  Marvel
//
//  Created by Nathan Ubeda on 12/1/24.
//

import Foundation

/// Enum of thumbnail components.
enum Thumbnail: Hashable, Codable {
	case url(String)
	case details(ThumbnailDetails)
}
