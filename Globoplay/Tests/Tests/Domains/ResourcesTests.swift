//
//  ResourcesTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class ResourcesTests: XCTestCase {

	func testGenresMap() {
		XCTAssertEqual(Genres.genresMap[28], "Ação")
		XCTAssertEqual(Genres.genresMap[10766], "Soap")
		XCTAssertNil(Genres.genresMap[1])
	}

	func testCountriesMap() {
		XCTAssertEqual(Countries.countriesMap["AD"], "Andorra")
		XCTAssertEqual(Countries.countriesMap["BR"], "Brasil")
		XCTAssertNil(Countries.countriesMap["not mapped index"])
	}
}
