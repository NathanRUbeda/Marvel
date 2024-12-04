//
//  MarvelServer.swift
//  MarvelAPIProject
//
//  Created by Nathan Ubeda on 10/15/24.
//

import CryptoKit
import Foundation
import ComposableArchitecturePattern
import OSLog

/// An actor that handles server interactions.
actor MarvelServer: Server {
	var environments: [ServerEnvironment]
	
	var additionalHTTPHeaders: [String: String]?
	
	var blockAllAPIsNotSupported: Bool = true
	
	var requestsBeingProcessed = Set<UUID>()
	
	var currentEnvironment: ServerEnvironment?
	
	var apis: [any ServerAPI]
	
	var logActivity: LogActivity
	
	init(
		environments: [ServerEnvironment],
		currentEnvironment: ServerEnvironment? = nil,
		additionalHTTPHeaders: [String : String]? = nil,
		supportedAPIs: [any ServerAPI],
		logActivity: LogActivity = .all
	) {
		self.environments = environments
		self.currentEnvironment = currentEnvironment
		self.additionalHTTPHeaders = additionalHTTPHeaders
		self.apis = supportedAPIs
		self.logActivity = logActivity
	}
	
	var logger: Logger {
		return Logger(subsystem: "MarvelServer", category: "Challenge1")
	}
	
	func checkAPIsContainAPI(_ api: any ServerAPI) throws {
		guard self.apis.contains(where: { $0.isEqual(to: api) }) else {
			throw ServerAPIError.badRequest(description: NSLocalizedString("API for path \(api.path) isn't supported.", comment: ""))
		}
	}
}

extension ServerAPI {
	func isEqual(to api: any ServerAPI) -> Bool {
		let returnObjectsEquatable = {
			if let supportedReturnObjects, let otherSupportedReturnObjects = api.supportedReturnObjects {
				return supportedReturnObjects.isEqual(to: otherSupportedReturnObjects)
			}
			return true
		}
		
		print("returnObjectsEquatable: \(returnObjectsEquatable())")
		
		let isEquatable = self.environment == api.environment && self.path == api.path && self.headers == api.headers && self.queries == api.queries && self.body == api.body && self.supportedHTTPMethods == api.supportedHTTPMethods && self.timeoutInterval == api.timeoutInterval && returnObjectsEquatable()
		
		print("isEquatable: \(isEquatable)")
		return isEquatable
	}
}
