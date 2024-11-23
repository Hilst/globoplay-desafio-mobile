//
//  DiscoverRequest.swift
//  Globoplay
//
//  Created by Felipe Hilst on 20/11/24.
//

import Foundation

struct ContentWrapper: Decodable {
	let results: [ContentDTO]
}

struct DiscoverRequest: Request {
	let type: PresentationType

	typealias ReturnType = ContentWrapper

	var path: [String]? { ["discover", type.apiString] }

	var addtionalQuery: [String : String]? {
		var query = [
			"sort_by": "popularity.desc",
			"with_companies": Network.Constants.globoplayCompaniesIdsQuery
		]
		switch type {
		case .tvshow:
			query["without_genres"] = "\(PresentationType.soapGenreId)"
		case .movie:
			break
		case .soap:
			query["with_genres"] = "\(PresentationType.soapGenreId)"
		}
		return query
	}

	var isContentJson = true
}
