//
//  DetailsRequestTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class DetailsRequestTests: XCTestCase {

	override class func setUp() {
		RequestProviderMock.setup()
	}

	override func tearDown() {
		RequestProviderMock.instance.reset()
	}

	func testDetailsRequest() async throws {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let response = DetailsDTO(id: 1, numberOfEpisodes: nil, originCountry: nil, credits: nil)
		RequestProviderMock.instance.response = try encoder.encode(response)

		let model = ContentModel(id: 1)
		model.presentation = PresentationType.soap.rawValue
		let result = try await DetailsRequest(content: model)
			.requestAndTransform(withProvider: RequestProviderMock.instance)

		let requestMade = RequestProviderMock.instance.spyArray.first
		guard let requestMade else {
			XCTFail()
			return
		}

		var urlString = "https://api.themoviedb.org"
		urlString += "/3/tv/1"
		urlString += "?api_key=test-key&language=en-US"
		urlString += "&append_to_response=credits"
		var expected = URLRequest(url: URL(string: urlString)!)
		expected.addValue("application/json", forHTTPHeaderField: "accept")
		pairArray(requestMade, expected).assert("Details request")

		XCTAssertEqual(result.id, 1)
	}
}
