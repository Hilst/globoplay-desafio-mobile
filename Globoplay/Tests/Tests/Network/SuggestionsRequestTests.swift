//
//  RecommendationsRequestTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class RecommendationsRequestTests: XCTestCase {

	override class func setUp() {
		RequestProviderMock.setup()
	}

	override func tearDown() {
		RequestProviderMock.instance.reset()
	}

	func testRecommendationsRequestTV() async throws {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let wrapper = ContentWrapper(results: [
			makeDTO(id: 1, isSoap: false, ptBR: true),
			makeDTO(id: 1, isSoap: false, ptBR: false),
		])
		RequestProviderMock.instance.response = try encoder.encode(wrapper)

		let input = ContentModel(id: 1)
		input.presentation = PresentationType.tvshow.rawValue
		let models = try await RecommendationsRequest(content: input)
			.requestAndTransform(withProvider: RequestProviderMock.instance)

		let requestMade = RequestProviderMock.instance.spyArray.first
		guard let requestMade else {
			XCTFail()
			return
		}

		var urlString = "https://api.themoviedb.org"
		urlString += "/3/tv/1/recommendations"
		urlString += "?api_key=test-key&language=en-US"
		var expected = URLRequest(url: URL(string: urlString)!)
		expected.addValue("application/json", forHTTPHeaderField: "accept")
		pairArray(requestMade, expected).assert("Recommendations request")

		XCTAssertEqual(models.count, 1)
		XCTAssertEqual(models.first?.presentation, PresentationType.tvshow.rawValue)
	}

	func testRecommendationsRequestSoap() async throws {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let wrapper = ContentWrapper(results: [
			makeDTO(id: 1, isSoap: false, ptBR: true),
			makeDTO(id: 1, isSoap: false, ptBR: false),
		])
		RequestProviderMock.instance.response = try encoder.encode(wrapper)

		let input = ContentModel(id: 1)
		input.presentation = PresentationType.soap.rawValue
		let models = try await RecommendationsRequest(content: input)
			.requestAndTransform(withProvider: RequestProviderMock.instance)

		let requestMade = RequestProviderMock.instance.spyArray.first
		guard let requestMade else {
			XCTFail()
			return
		}

		var urlString = "https://api.themoviedb.org"
		urlString += "/3/tv/1/recommendations"
		urlString += "?api_key=test-key&language=en-US"
		var expected = URLRequest(url: URL(string: urlString)!)
		expected.addValue("application/json", forHTTPHeaderField: "accept")
		pairArray(requestMade, expected).assert("Recommendations request")

		XCTAssertEqual(models.count, 1)
		XCTAssertEqual(models.first?.presentation, PresentationType.soap.rawValue)
	}

	func testRecommendationsRequestMovies() async throws {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let wrapper = ContentWrapper(results: [
			makeDTO(id: 1, isSoap: false, ptBR: true),
			makeDTO(id: 1, isSoap: false, ptBR: false),
		])
		RequestProviderMock.instance.response = try encoder.encode(wrapper)

		let input = ContentModel(id: 1)
		input.presentation = PresentationType.movie.rawValue
		let models = try await RecommendationsRequest(content: input)
			.requestAndTransform(withProvider: RequestProviderMock.instance)

		let requestMade = RequestProviderMock.instance.spyArray.first
		guard let requestMade else {
			XCTFail()
			return
		}

		var urlString = "https://api.themoviedb.org"
		urlString += "/3/movie/1/recommendations"
		urlString += "?api_key=test-key&language=en-US"
		var expected = URLRequest(url: URL(string: urlString)!)
		expected.addValue("application/json", forHTTPHeaderField: "accept")
		pairArray(requestMade, expected).assert("Recommendations request")

		XCTAssertEqual(models.count, 1)
		XCTAssertEqual(models.first?.presentation, PresentationType.movie.rawValue)
	}
}

extension RecommendationsRequestTests {
	func makeDTO(id: Int, isSoap: Bool, ptBR: Bool) -> ContentDTO {
		.init(id: id,
			  title: nil,
			  originalTitle: nil,
			  name: nil,
			  originalName: nil,
			  overview: nil,
			  genreIds: [isSoap ? PresentationType.soapGenreId : 1],
			  originalLanguage: ptBR ? "pt" : "en",
			  posterPath: nil,
			  firstAirDate: nil,
			  releaseDate: nil)
	}
}
