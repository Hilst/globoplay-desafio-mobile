//
//  ContentModel.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

import SwiftData

@Model
final class ContentModel: Equatable {
	@Attribute(.unique) var id: Int
	var title: String?
	var originalTitle: String?
	var overview: String?
	var genreIds: [Int]?
	var originalLanguage: String?
	var posterPath: String?
	var releaseDate: String?

	var presentation: Int?

	var isSoap: Bool {
		genreIds?.contains { $0 == PresentationType.soapGenreId } ?? false
	}

	init(
		id: Int,
		title: String? = nil,
		originalTitle: String? = nil,
		genreIds: [Int]? = nil,
		originalLanguage: String? = nil,
		posterPath: String? = nil,
		releaseDate: String? = nil
	) {
		self.id = id
		self.title = title
		self.originalTitle = originalTitle
		self.genreIds = genreIds
		self.originalLanguage = originalLanguage
		self.posterPath = posterPath
		self.releaseDate = releaseDate
	}

	convenience init(dto: ContentDTO) {
		self.init(id: dto.id)
		self.title = dto.title ?? dto.name
		self.originalTitle = dto.originalTitle ?? dto.originalName
		self.overview = dto.overview
		self.genreIds = dto.genreIds
		self.originalLanguage = dto.originalLanguage
		self.posterPath = dto.posterPath
		self.releaseDate = dto.releaseDate ?? dto.firstAirDate
	}
}

struct ContentDTO: Decodable {
	let id: Int
	let title: String?
	let originalTitle: String?
	let name: String?
	let originalName: String?
	let overview: String?
	let genreIds: [Int]?
	let originalLanguage: String?
	let posterPath: String?
	let firstAirDate: String?
	let releaseDate: String?
}
