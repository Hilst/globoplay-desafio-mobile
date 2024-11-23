//
//  ContentDetailsView+DetailsItem.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//

import SwiftUI

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
			.filter { $0.job == "Director" }
			.compactMap { $0.name }
		self.castNames = dto.credits?.cast?
			.compactMap { $0.name }
	}
}

struct SpecifDetailsRequest: RequestWithTransformation {
	typealias ReturnType = SpecifDetailsDTO

	let content: ContentModel

	var path: [String]? {
		let typeId = content.presentation ?? PresentationType.movie.rawValue
		let type = PresentationType(rawValue: typeId) ?? .movie
		return [
			type.apiString,
			content.id.description
		]
	}

	let addtionalQuery: [String : String]? = [ "append_to_response": "credits" ]
	let isContentJson: Bool = true

	typealias TransformationResult = SpecifDetailsModel
	func transformation(_ returned: SpecifDetailsDTO) -> SpecifDetailsModel {
		SpecifDetailsModel(dto: returned)
	}
}

enum TechnicalDetailsItem {
	static var allCases: [TechnicalDetailsItem] = [
		.originalTile(nil),
		.genersConcatened(nil),
		.episodesNumber(nil),
		.yearOfProduction(nil),
		.country(nil),
		.directorsNames(nil),
		.castConcatened(nil),
	]

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

final class TechnicalDetailsViewModel: ObservableObject {
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
}

struct TechnicalDetailsView: View {
	@ObservedObject var viewModel: TechnicalDetailsViewModel
	init(viewData: ContentViewData) {
		viewModel = TechnicalDetailsViewModel(viewData: viewData)
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text("Ficha técnica")
				.foregroundStyle(.white)
				.font(.title2)
				.fontWeight(.bold)
				.padding(.vertical, 30)
				.padding(.horizontal)
			ForEach(viewModel.items, id: \.self) { item in
				Text(item)
					.foregroundStyle(.gray)
					.multilineTextAlignment(.leading)
			}
			.padding(.horizontal)
			Spacer()
		}
		.containerRelativeFrame([.horizontal], alignment: .topLeading)
		.task {
			try? await viewModel.updateDetails()
		}
	}
}

extension ContentDetailsItemsView {
	enum DetailsItem: Int, CaseIterable {
		case suggestions, technicalDetails

		var title: String {
			switch self {
			case .suggestions: "ASSISTA TAMBÉM"
			case .technicalDetails: "DETALHES"
			}
		}

		@ViewBuilder
		func view(viewData: ContentViewData) -> some View {
			switch self {
			case .suggestions:
				SuggestionsView(viewData: viewData)
			case .technicalDetails:
				TechnicalDetailsView(viewData: viewData)
			}
		}

		@ViewBuilder
		func pickerView(_ state: State<Self>) -> some View {
			Button { state.wrappedValue = self }
			label: {
					Group {
						if state.wrappedValue == self {
							Text(self.title)
								.background(
									Color.white
										.frame(height: 2)
										.offset(y: 20)
								)
						} else {
							Text(self.title)
								.foregroundStyle(.gray)
						}
					}
			}
		}
	}
}
