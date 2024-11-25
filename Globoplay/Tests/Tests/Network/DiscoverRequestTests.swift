//
//  DiscoverRequestTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class DiscoverRequestTests: XCTestCase {

	override class func setUp() {
		RequestProviderMock.setup()
	}

	override func tearDown() {
		RequestProviderMock.instance.reset()
	}

	func testDiscoverRequestTV() async throws {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let wrapper = ContentWrapper(results: [makeDTO(isSoap: false)])
		RequestProviderMock.instance.response = try encoder.encode(wrapper)

		let models = try await DiscoverRequest(type: .tvshow)
			.requestAndTransform(withProvider: RequestProviderMock.instance)

		let requestMade = RequestProviderMock.instance.spyArray.first
		guard let requestMade else {
			XCTFail()
			return
		}

		var urlString = "https://api.themoviedb.org"
		urlString += "/3/discover/tv"
		urlString += "?api_key=test-key&language=en-US"
		urlString += "&with_companies=\(Network.Constants.globoplayCompaniesIdsQuery)"
		urlString += "&without_genres=\(PresentationType.soapGenreId)"
		urlString += "&sort_by=popularity.desc"
		var expected = URLRequest(url: URL(string: urlString)!)
		expected.addValue("application/json", forHTTPHeaderField: "accept")
		pairArray(requestMade, expected).assert("Discover request")

		XCTAssertEqual(models.first?.presentation, PresentationType.tvshow.rawValue)
	}

	func testDiscoverRequestSoap() async throws {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let wrapper = ContentWrapper(results: [makeDTO(isSoap: true)])
		RequestProviderMock.instance.response = try encoder.encode(wrapper)

		let models = try await DiscoverRequest(type: .soap)
			.requestAndTransform(withProvider: RequestProviderMock.instance)

		let requestMade = RequestProviderMock.instance.spyArray.first
		guard let requestMade else {
			XCTFail()
			return
		}

		var urlString = "https://api.themoviedb.org"
		urlString += "/3/discover/tv"
		urlString += "?api_key=test-key&language=en-US"
		urlString += "&with_companies=\(Network.Constants.globoplayCompaniesIdsQuery)"
		urlString += "&with_genres=\(PresentationType.soapGenreId)"
		urlString += "&sort_by=popularity.desc"
		var expected = URLRequest(url: URL(string: urlString)!)
		expected.addValue("application/json", forHTTPHeaderField: "accept")
		pairArray(requestMade, expected).assert("Discover request")

		XCTAssertEqual(models.first?.presentation, PresentationType.soap.rawValue)
	}

	func testDiscoverRequestMovies() async throws {
		let encoder = JSONEncoder()
		encoder.keyEncodingStrategy = .convertToSnakeCase
		let wrapper = ContentWrapper(results: [makeDTO(isSoap: false)])
		RequestProviderMock.instance.response = try encoder.encode(wrapper)

		let models = try await DiscoverRequest(type: .movie)
			.requestAndTransform(withProvider: RequestProviderMock.instance)

		let requestMade = RequestProviderMock.instance.spyArray.first
		guard let requestMade else {
			XCTFail()
			return
		}

		var urlString = "https://api.themoviedb.org"
		urlString += "/3/discover/movie"
		urlString += "?api_key=test-key&language=en-US"
		urlString += "&with_companies=\(Network.Constants.globoplayCompaniesIdsQuery)"
		urlString += "&sort_by=popularity.desc"
		var expected = URLRequest(url: URL(string: urlString)!)
		expected.addValue("application/json", forHTTPHeaderField: "accept")
		pairArray(requestMade, expected).assert("Discover request")

		XCTAssertEqual(models.first?.presentation, PresentationType.movie.rawValue)
	}
}

extension DiscoverRequestTests {
	func makeDTO(isSoap: Bool) -> ContentDTO {
		.init(id: 1,
			  title: nil,
			  originalTitle: nil,
			  name: nil,
			  originalName: nil,
			  overview: nil,
			  genreIds: [isSoap ? PresentationType.soapGenreId : 1],
			  originalLanguage: nil,
			  posterPath: nil,
			  firstAirDate: nil,
			  releaseDate: nil)
	}
}
