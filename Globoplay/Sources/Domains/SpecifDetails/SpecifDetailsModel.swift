//
//  SpecifDetailsDTO.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

struct SpecifDetailsDTO: Decodable {
	let id: Int
	let numberOfEpisodes: Int?
	let originCountry: [String]?
	let credits: CreditsDTO?
	struct CreditsDTO: Decodable {
		let cast: [CastDTO]?
		struct CastDTO: Decodable {
			let name: String?
		}
		let crew: [CrewDTO]?
		struct CrewDTO: Decodable {
			let name: String?
			let job: String?
		}
	}
}

struct SpecifDetailsModel {
	let id: Int
	let numberOfEpisodes: Int?
	let firstOriginCountry: String?
	let directorsNames: [String]?
	let castNames: [String]?

	init(dto: SpecifDetailsDTO) {
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
	private static func isDirector(_ crew: SpecifDetailsDTO.CreditsDTO.CrewDTO) -> Bool {
		crew.job == directorJobString
	}
}
