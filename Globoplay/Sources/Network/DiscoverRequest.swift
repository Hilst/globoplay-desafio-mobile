//
//  DiscoverRequest.swift
//  Globoplay
//
//  Created by Felipe Hilst on 20/11/24.
//

import Foundation

struct Wrapper: Decodable {
	let results: [ContentDTO]
}

enum DiscoverType: String {
	case tv, movie
}

struct DiscoverRequest: Request {
	var method: RequestMethod?
	
	var timeout: Double?
	
	let type: DiscoverType
	var path: [String]? { ["discover", type.rawValue] }
	var addtionalQuery: [String : String]? {
		[ "sort_by": "popularity.desc",
		  "with_companies": Network.Constants.globoplayCompaniesIdsQuery ]
	}
	var isContentJson = true

	func make() async throws -> [ContentModel] {
		let data = try await Network.request(self)
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let decoded = try decoder.decode(Wrapper.self, from: data)
		return decoded.results.map { ContentModel(dto: $0) }
	}
}
