//
//  ContentDomainTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class ContentDomainTests: XCTestCase {

	func testContentDTOToModelMovies() {
		let moviesDTO = ContentDTO(id: 1,
								   title: "t",
								   originalTitle: "ot",
								   name: nil,
								   originalName: nil,
								   overview: "o",
								   genreIds: [1,2,3],
								   originalLanguage: "ol",
								   posterPath: "pp",
								   firstAirDate: nil,
								   releaseDate: "rd")

		let moviesModel = ContentModel(dto: moviesDTO)

		let expected = ContentModel(id: 1,
									title: "t",
									originalTitle: "ot",
									overview: "o",
									genreIds: [1,2,3],
									originalLanguage: "ol",
									posterPath: "pp",
									releaseDate: "rd")

		pairArray(moviesModel, expected).assert()
	}

	func testContentDTOToModelTV() {
		let tvDTO = ContentDTO(id: 1,
							   title: nil,
							   originalTitle: nil,
							   name: "n",
							   originalName: "on",
							   overview: "o",
							   genreIds: [1,2,3],
							   originalLanguage: "ol",
							   posterPath: "pp",
							   firstAirDate: "fad",
							   releaseDate: nil)

		let tvModel = ContentModel(dto: tvDTO)

		let expected = ContentModel(id: 1,
									title: "n",
									originalTitle: "on",
									overview: "o",
									genreIds: [1,2,3],
									originalLanguage: "ol",
									posterPath: "pp",
									releaseDate: "fad")

		pairArray(tvModel, expected).assert()
	}
}
