//
//  TechnicalDetailsViewModel.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

import SwiftUI

final class TechnicalDetailsViewModel: ObservableObject {
	enum TechnicalDetailsItem {
		case originalTile(String?)
		case genersConcatened([Int]?)
		case episodesNumber(Int?)
		case yearOfProduction(Int?)
		case country(String?)
		case directorsNames([String]?)
		case castConcatened([String]?)

		var label: String {
			switch self {
			case .originalTile: "Título Original"
			case .genersConcatened: "Gênero"
			case .episodesNumber: "Episódios"
			case .yearOfProduction: "Ano de Produção"
			case .country: "País"
			case .directorsNames: "Direção"
			case .castConcatened: "Elenco"
			}
		}
	}

	@Published var items = [AttributedString]()
	let viewData: ContentViewData

	private static let formatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-dd"
		return formatter
	}()

	init(viewData: ContentViewData) {
		self.viewData = viewData
	}

	func updateDetails() async throws {
		async let details = try? await SpecifDetailsRequest(content: viewData.content).requestAndTransform()

		var productionYear: Int? = nil
		if let releaseDateString = viewData.content.releaseDate,
		   let releaseDate = Self.formatter.date(from: releaseDateString) {
			productionYear = releaseDate.get(.year)
		}

		await updateItems(with: [
			.originalTile(viewData.content.originalTitle),
			.genersConcatened(viewData.content.genreIds),
			.episodesNumber(details?.numberOfEpisodes),
			.yearOfProduction(productionYear),
			.country(details?.firstOriginCountry),
			.directorsNames(details?.directorsNames?.prefix(3).asArray()),
			.castConcatened(details?.castNames?.prefix(10).asArray()),
		])
	}

	private func updateItems(with values: [TechnicalDetailsItem]) async {
		await MainActor.run {
			items = values.compactMap { item in
				guard let textValue = toText(item: item) else { return nil }
				return try? AttributedString(markdown: "**\(item.label):** \(textValue)")
			}
		}
	}

	private func toText(item: TechnicalDetailsItem) -> String? {
		switch item {
		case .genersConcatened(let genres):
			guard let genres, !genres.isEmpty else { return nil }
			return genres
				.compactMap { Genres.genresMap[$0] }
				.joined(separator: ", ")

		case .episodesNumber(let number): fallthrough
		case .yearOfProduction(let number):
			guard let number else { return nil }
			return number.description

		case .originalTile(let string): fallthrough
		case .country(let string):
			return string

		case .directorsNames(let names): fallthrough
		case .castConcatened(let names):
			guard let names, !names.isEmpty else { return nil }
			return names.joined(separator: ", ")
		}
	}
}
