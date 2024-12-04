//
//  MarvelComicAPI.swift
//  MarvelAPIProject
//
//  Created by Nathan Ubeda on 10/15/24.
//

import ComposableArchitecturePattern
import Foundation

/// An object that specifies a specific server API.
struct MarvelComicAPI: ServerAPI {
	init(
		environment: ComposableArchitecturePattern.ServerEnvironment?,
		path: String = "comics",
		headers: [String : String]?,
		queries: [URLQueryItem]?,
		supportedHTTPMethods: [ComposableArchitecturePattern.HTTPMethod] = [.GET],
		supportedReturnObjects: [any Codable.Type]? = [MarvelAPIResponse.self],
		timeoutInterval: TimeInterval = 1000
	) {
		self.environment = environment
		self.path = path
		self.headers = headers
		self.queries = queries
		self.supportedHTTPMethods = supportedHTTPMethods
		self.supportedReturnObjects = supportedReturnObjects
		self.timeoutInterval = timeoutInterval
	}
	
	/// Whether or not the provided type is supported by the API. Defaults to checking if the type is found in `supportedReturnObjects` or returning `false` if not found.
	func supports<T: Codable>(_ object: T.Type) -> Bool {
		return self.supportedReturnObjects?.contains(where: { $0 == object }) ?? false
	}
	
	/// Conforms to Equatable protocol.
	static func == (lhs: MarvelComicAPI, rhs: MarvelComicAPI) -> Bool {
		return lhs.id == rhs.id
	}
	
	let id = UUID()
	var environment: ComposableArchitecturePattern.ServerEnvironment?
	var headers: [String : String]?
	var body: Data?
	var path: String
	var queries: [URLQueryItem]?
	var supportedHTTPMethods: [HTTPMethod]
	var supportedReturnObjects: [Codable.Type]?
	var timeoutInterval: TimeInterval
}
