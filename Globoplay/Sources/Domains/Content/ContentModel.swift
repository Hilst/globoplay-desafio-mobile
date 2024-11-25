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
		overview: String? = nil,
		genreIds: [Int]? = nil,
		originalLanguage: String? = nil,
		posterPath: String? = nil,
		releaseDate: String? = nil
	) {
		self.id = id
		self.title = title
		self.originalTitle = originalTitle
		self.overview = overview
		self.genreIds = genreIds
		self.originalLanguage = originalLanguage
		self.posterPath = posterPath
		self.releaseDate = releaseDate
	}

	convenience init(dto: ContentDTO) {
		self.init(
			id: dto.id,
			title: dto.title ?? dto.name,
			originalTitle: dto.originalTitle ?? dto.originalName,
			overview: dto.overview,
			genreIds: dto.genreIds,
			originalLanguage: dto.originalLanguage,
			posterPath: dto.posterPath,
			releaseDate: dto.releaseDate ?? dto.firstAirDate
		)
	}
}

struct ContentDTO: Codable {
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
