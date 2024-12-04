//
//  MarvelCharacterAPI.swift
//  MarvelAPIProject
//
//  Created by Nathan Ubeda on 10/15/24.
//

import ComposableArchitecturePattern
import Foundation

/// An object that specifies a server API.
struct MarvelCharacterAPI: ServerAPI {
	init(
		environment: ComposableArchitecturePattern.ServerEnvironment?,
		path: String = "characters",
		headers: [String : String]?,
		queries: [URLQueryItem]?,
		supportedHTTPMethods: [ComposableArchitecturePattern.HTTPMethod] = [.GET],
		supportedReturnObjects: [any Decodable.Type] = [MarvelAPIResponse.self],
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
	
	let id = UUID()
	var environment: ComposableArchitecturePattern.ServerEnvironment?
	var headers: [String : String]?
	var body: Data?
	var path: String
	var queries: [URLQueryItem]?
	var supportedHTTPMethods: [HTTPMethod]
	var supportedReturnObjects: [Decodable.Type]?
	var timeoutInterval: TimeInterval
}
