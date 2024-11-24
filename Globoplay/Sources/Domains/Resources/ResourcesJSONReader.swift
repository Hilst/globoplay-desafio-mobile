//
//  Reader.swift
//  Globoplay
//
//  Created by Felipe Hilst on 24/11/24.
//

import Foundation

enum Resource: String {
	case moviesGenres = "genres_movies"
	case tvGenres = "genres_tv"
	case countries = "countries_iso"
}

final class ResourcesJSONReader {
	private init() { }
	
	private static let bundle = {
		Bundle(for: ResourcesJSONReader.self)
	}()

	static func read<T: Decodable>(resource: Resource) -> T? {
		guard let file = Self.bundle.path(forResource: resource.rawValue, ofType: "json"),
			  let data = try? Data(contentsOf: URL(filePath: file))
		else { return nil }
		return try? JSONDecoder().decode(T.self, from: data)
	}
}
