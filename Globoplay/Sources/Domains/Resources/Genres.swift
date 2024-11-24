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

struct Genres {
	static let genresMap: [Int: String] = {
		let setGenres = Self.loadGenres()
		return Dictionary(uniqueKeysWithValues: setGenres.lazy.map { ($0.id, $0.name) })
	}()

	private static func loadGenres() -> Set<Genre> {
		let genresFiles = [ Resource.moviesGenres, .tvGenres ]
		let genres = genresFiles
			.compactMap { resource in
				let wrapper: GenresWrapper? = ResourcesJSONReader.read(resource: resource)
				return wrapper?.genres
			}
			.lazy.flatMap { $0 }
		return Set(genres)
	}
}
