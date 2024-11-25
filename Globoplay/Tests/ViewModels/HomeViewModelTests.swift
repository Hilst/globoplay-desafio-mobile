//
//  HomeViewModelTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class HomeViewModelTests: XCTestCase {

	override class func setUp() {
		RequestProviderMock.setup()
	}

	override func tearDown() {
		RequestProviderMock.instance.reset()
	}

	func testGetSuggestions() async throws {
		try prepareRequest()
		let sut = makeSut()
		XCTAssertTrue(sut.isLoading)
		XCTAssertTrue(sut.isEmpty)

		try await sut.updateContent()

		XCTAssertFalse(sut.isLoading)
		XCTAssertFalse(sut.isEmpty)
		XCTAssertEqual(sut.contents[.movie]?.count, 3)
		XCTAssertEqual(sut.contents[.tvshow]?.count, 3)
		XCTAssertEqual(sut.contents[.soap]?.count, 3)
		pairArray(
			sut.contents[.movie]?.first?.presentationTitle,
			"Cinema"
		).assertPair()
		pairArray(
			sut.contents[.tvshow]?.first?.presentationTitle,
			"Shows"
		).assertPair()
		pairArray(
			sut.contents[.soap]?.first?.presentationTitle,
			"Soap"
		).assertPair()
	}

	func testGetSuggestionsWithErrors() async throws {
		let sut = makeSut()
		XCTAssertTrue(sut.isLoading)
		XCTAssertTrue(sut.isEmpty)

		try await sut.updateContent()

		XCTAssertFalse(sut.isLoading)
		XCTAssertTrue(sut.isEmpty)
	}

	func prepareRequest() throws {
		let dtos = (0..<3).map { index in
			ContentDTO(id: index,
					   title: nil,
					   originalTitle: nil,
					   name: nil,
					   originalName: nil,
					   overview: nil,
					   genreIds: nil,
					   originalLanguage: "pt",
					   posterPath: nil,
					   firstAirDate: nil,
					   releaseDate: nil)
		}
		let wrapper = ContentWrapper(results: dtos)
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let data = try encoder.encode(wrapper)
		RequestProviderMock.instance.response = data
	}
}

extension HomeViewModelTests {
	func makeSut() -> HomeViewModel {
		return HomeViewModel()
	}
}
