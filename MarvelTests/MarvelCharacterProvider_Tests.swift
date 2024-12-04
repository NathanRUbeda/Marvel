//
//  MarvelCharacterProvider_Tests.swift
//  MarvelTests
//
//  Created by Nathan Ubeda on 12/3/24.
//

import XCTest
@testable import Marvel

final class MarvelCharacterProvider_Tests: XCTestCase {
	var characterProvider: CharacterProvidable?
	
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		characterProvider = MockCharacterProvider()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
		characterProvider = nil
    }

	func test_CharacterProvider_fetchCharacters_shouldFetchCharacters() async throws {
		// Given
		guard let characterProvider else {
			XCTFail()
			return
		}
		
		// When
		let response = try await characterProvider.fetchCharacters(shouldIncrementCharacterOffset: true)
		
		// Then
		XCTAssertNotNil(response)
	}
	
	func test_CharacterProvider_fetchSearchedCharacters_shouldFetchSpecificCharacters() async throws {
		// Given
		guard let characterProvider else {
			XCTFail()
			return
		}
		
		// When
		let names = ["hulk", "venom", "groot"]
		
		// Then
		for name in names {
			let response = try await characterProvider.fetchSearchedCharacters(name: name)
			XCTAssertNotNil(response)
		}
	}
}
