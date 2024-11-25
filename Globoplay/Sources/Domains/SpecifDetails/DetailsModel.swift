//
//  DetailsDTO.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

struct DetailsDTO: Codable {
	let id: Int
	let numberOfEpisodes: Int?
	let originCountry: [String]?
	let credits: CreditsDTO?
	struct CreditsDTO: Codable {
		let cast: [CastDTO]?
		struct CastDTO: Codable {
			let name: String?
		}
		let crew: [CrewDTO]?
		struct CrewDTO: Codable {
			let name: String?
			let job: String?
		}
	}
}

struct DetailsModel {
	let id: Int
	let numberOfEpisodes: Int?
	let firstOriginCountry: String?
	let directorsNames: [String]?
	let castNames: [String]?

	init(dto: DetailsDTO) {
		self.id = dto.id
		self.numberOfEpisodes = dto.numberOfEpisodes
		self.firstOriginCountry = dto.originCountry?.first
		self.directorsNames = dto.credits?.crew?
			.filter(Self.isDirector)
			.compactMap { $0.name }
		self.castNames = dto.credits?.cast?
			.compactMap { $0.name }
	}

	static let directorJobString = "Director"
	private static func isDirector(_ crew: DetailsDTO.CreditsDTO.CrewDTO) -> Bool {
		crew.job == directorJobString
	}
}
