//
//  DetailsViewModelTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class TechnicalDetailsViewModelTests: XCTestCase {

	override class func setUp() {
		RequestProviderMock.setup()
	}

	override func tearDown() {
		RequestProviderMock.instance.reset()
	}

	func testUpdateDetails() async throws {
		try prepareRequest()
		let sut = makeSut()
		XCTAssertTrue(sut.isLoading)
		XCTAssertTrue(sut.isEmpty)

		try await sut.updateDetails()

		XCTAssertFalse(sut.isLoading)
		XCTAssertFalse(sut.isEmpty)

		let comparable = sut.items.map { String($0.characters) }
		let expected = [
			"Original Title: ot",
			"Genre: Soap, Talk",
			"Episodes: 20",
			"Production Year: 2000",
			"Country: Brasil",
			"Direction: crew-2, crew-4",
			"Cast: cast-1, cast-2",
		]
		XCTAssertEqual(comparable, expected)
	}

	func testUpdateDetailsWithError() async throws {
		let sut = makeSut()
		XCTAssertTrue(sut.isLoading)
		XCTAssertTrue(sut.isEmpty)

		try await sut.updateDetails()

		XCTAssertFalse(sut.isLoading)
		XCTAssertFalse(sut.isEmpty)

		let comparable = sut.items.map { String($0.characters) }
		let expected = [
			"Original Title: ot",
			"Genre: Soap, Talk",
			"Production Year: 2000",
		]
		XCTAssertEqual(comparable, expected)
	}

	func prepareRequest() throws {
		let cast = [ DetailsDTO.CreditsDTO.CastDTO(name: "cast-1"),
					 .init(name: "cast-2") ]
		let crew = [ DetailsDTO.CreditsDTO.CrewDTO(name: "crew-1", job: "crew"),
					 .init(name: "crew-2", job: "Director"),
					 .init(name: "crew-3", job: "crew"),
					 .init(name: "crew-4", job: "Director") ]
		let credits = DetailsDTO.CreditsDTO(cast: cast, crew: crew)
		let dto = DetailsDTO(id: 1,
							 numberOfEpisodes: 20,
							 originCountry: ["BR"],
							 credits: credits)
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let data = try encoder.encode(dto)
		RequestProviderMock.instance.response = data
	}
}

extension TechnicalDetailsViewModelTests {
	func makeSut() -> TechnicalDetailsViewModel {
		let model = ContentModel(id: 1,
								 originalTitle: "ot",
								 genreIds: [10766, 10767],
								 releaseDate: "2000-01-01")
		model.presentation = PresentationType.movie.rawValue
		let viewData = ContentViewData(content: model)
		return TechnicalDetailsViewModel(viewData: viewData)
	}
}
