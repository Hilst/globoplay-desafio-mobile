//
//  SuggestionsViewModelTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class SuggestionsViewModelTests: XCTestCase {

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

		try await sut.getSuggestions()

		XCTAssertFalse(sut.isLoading)
		XCTAssertFalse(sut.isEmpty)
		XCTAssertEqual(sut.suggestedViewDatas.count, 6)
	}

	func testGetSuggestionsWitherrors() async throws {
		let sut = makeSut()
		XCTAssertTrue(sut.isLoading)
		XCTAssertTrue(sut.isEmpty)

		try await sut.getSuggestions()

		XCTAssertFalse(sut.isLoading)
		XCTAssertTrue(sut.isEmpty)
	}

	func prepareRequest() throws {
		let dtos = (0..<7).map { index in
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

extension SuggestionsViewModelTests {
	func makeSut() -> SuggestionsViewModel {
		let model = ContentModel(id: 1)
		model.presentation = PresentationType.movie.rawValue
		let viewData = ContentViewData(content: model)
		return SuggestionsViewModel(originalContentViewData: viewData)
	}
}
