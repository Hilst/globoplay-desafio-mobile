//
//  Genre.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//
import Foundation

fileprivate struct GenresWrapper: Decodable {
	let genres: [Genre]
}

fileprivate struct Genre: Decodable, Hashable {
	let id: Int
	let name: String
}

final class Genres {
	private enum Resource: String {
		case movies = "genres_movies"
		case tv = "genres_tv"
	}

	static let genresMap: [Int: String] = {
		let allGenres = readGenres(resource: .movies) + readGenres(resource: .tv)
		let setGenres = Set(allGenres)
		return Dictionary(uniqueKeysWithValues: setGenres.lazy.map { ($0.id, $0.name) })
	}()

	private static let bundle = Bundle(for: Genres.self)

	private static func readGenres(resource: Resource) -> [Genre] {
		guard let file = bundle.path(forResource: resource.rawValue, ofType: "json"),
			  let data = try? Data(contentsOf: URL(filePath: file)),
			  let genresWrapper = try? JSONDecoder().decode(GenresWrapper.self, from: data)
		else { return [] }
		return genresWrapper.genres
	}
}
