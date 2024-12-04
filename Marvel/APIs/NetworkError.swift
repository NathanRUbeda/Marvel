//
//  NetworkError.swift
//  Marvel
//
//  Created by Nathan Ubeda on 12/3/24.
//

import Foundation

/// Enum of possible server errors.
enum ServerError: Error {
	case totalReached
	case missingJSON
	case loadingError
	}
