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
	var overview: String?
	var genreIds: [Int]?
	var originalLanguage: String?
	var posterPath: String?

	var presentation: Int?

	var isSoap: Bool {
		genreIds?.contains { $0 == PresentationType.soapGenreId } ?? false
	}

	init(
		id: Int,
		title: String? = nil,
		genreIds: [Int]? = nil,
		originalLanguage: String? = nil,
		posterPath: String? = nil
	) {
		self.id = id
		self.title = title
		self.genreIds = genreIds
		self.originalLanguage = originalLanguage
		self.posterPath = posterPath
	}


	convenience init(dto: ContentDTO) {
		self.init(id: dto.id)
		self.title = dto.title ?? dto.name
		self.overview = dto.overview
		self.genreIds = dto.genreIds
		self.originalLanguage = dto.originalLanguage
		self.posterPath = dto.posterPath
	}
}

struct ContentDTO: Decodable {
	let id: Int
	let title: String?
	let name: String?
	let overview: String?
	let genreIds: [Int]?
	let originalLanguage: String?
	let posterPath: String?
}
