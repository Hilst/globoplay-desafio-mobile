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
	var posterPath: String?

	var presentationTitle: String?

	var isSoap: Bool {
		genreIds?.contains { $0 == PresentationType.soapGenreId } ?? false
	}

	init(id: Int, title: String? = nil, genreIds: [Int]? = nil, posterPath: String? = nil) {
		self.id = id
		self.title = title
		self.genreIds = genreIds
		self.posterPath = posterPath
	}


	convenience init(dto: ContentDTO) {
		self.init(id: dto.id)
		self.title = dto.title ?? dto.name
		self.overview = dto.overview
		self.genreIds = dto.genreIds
		self.posterPath = dto.posterPath
	}
}

struct ContentDTO: Decodable {
	let id: Int
	let title: String?
	let name: String?
	let overview: String?
	let genreIds: [Int]?
	let posterPath: String?
}
