//
//  DetailsModelsTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class DetailsModelsTests: XCTestCase {

	func testDTOToModel() {
		let cast = [ DetailsDTO.CreditsDTO.CastDTO(name: "cast-1"),
					 .init(name: "cast-2") ]
		let crew = [ DetailsDTO.CreditsDTO.CrewDTO(name: "crew-1", job: "crew"),
					 .init(name: "crew-2", job: "Director"),
					 .init(name: "crew-3", job: "crew"),
					 .init(name: "crew-4", job: "Director") ]
		let credits = DetailsDTO.CreditsDTO(cast: cast, crew: crew)
		let dto = DetailsDTO(id: 1,
								   numberOfEpisodes: 20,
								   originCountry: [ "BR", "US" ],
								   credits: credits)

		let model = DetailsModel(dto: dto)

		XCTAssertEqual(model.id, 1)
		XCTAssertEqual(model.numberOfEpisodes, 20)
		XCTAssertEqual(model.firstOriginCountry, "BR")
		XCTAssertEqual(model.castNames, ["cast-1", "cast-2"])
		XCTAssertEqual(model.directorsNames, ["crew-2", "crew-4"])
	}
}
