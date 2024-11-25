//
//  ContentViewDataTests.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

final class ContentViewDataTests: XCTestCase {

	func testModelToViewData() {
		let model = ContentModel(id: 1, title: "t")
		model.presentation = PresentationType.movie.rawValue

		let viewData = ContentViewData(content: model)

		pairArray(viewData.content, model).assert("ViewData content model")
		pairArray(viewData.title, model.title).assertPair("ViewData title and model not equal")
		pairArray(viewData.presentationTitle, PresentationType.movie.title).assertPair("Model presentation not passed")
	}

	func testModelToViewDataFallbacks() {
		let model = ContentModel(id: 1)
		let viewData = ContentViewData(content: model)

		pairArray(viewData.content, model).assert("ViewData content model")
		pairArray(viewData.title, String()).assertPair()
		pairArray(viewData.presentationTitle, nil).assertPair()
		pairArray(viewData.posterURL(size: .all), nil).assertPair()
	}

	func testViewDataPosterURL() {
		let model = ContentModel(id: 1, title: "t", posterPath: "/pp")
		model.presentation = PresentationType.movie.rawValue
		let viewData = ContentViewData(content: model)

		let urlsPairs = [[viewData.posterURL(size: .small)?.absoluteString, "https://image.tmdb.org/t/p/w185/pp"],
						 [viewData.posterURL(size: .big)?.absoluteString, "https://image.tmdb.org/t/p/w342/pp"],
						 [viewData.posterURL(size: .all)?.absoluteString, "https://image.tmdb.org/t/p/w780/pp"]]
		for pair in urlsPairs {
			pair.assertPair("URL string not generated correctly")
		}
	}

}
