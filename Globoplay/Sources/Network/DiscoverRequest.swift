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

enum DiscoverType: String {
	case tv, movie
}

struct DiscoverRequest: Request {
	typealias ReturnType = ContentWrapper
	var method: RequestMethod?
	
	var timeout: Double?
	
	let type: DiscoverType
	var path: [String]? { ["discover", type.rawValue] }
	var addtionalQuery: [String : String]? {
		[ "sort_by": "popularity.desc",
		  "with_companies": Network.Constants.globoplayCompaniesIdsQuery ]
	}
	var isContentJson = true
}
