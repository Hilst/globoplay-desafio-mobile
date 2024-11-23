//
//  ContentDetailsView+DetailsItem.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//

import SwiftUI

enum TechnicalDetailsItem {
	static var allCases: [TechnicalDetailsItem] = [
		.originalTile(nil),
		.genersConcatened(nil),
		.episodesNumber(nil),
		.yearOfProduction(nil),
		.country(nil),
		.directorName(nil),
		.castConcatened(nil),
	]

	case originalTile(String?)
	case genersConcatened([Int]?)
	case episodesNumber(Int?)
	case yearOfProduction(Int?)
	case country(String?)
	case directorName(String?)
	case castConcatened([String]?)

	var label: String {
		switch self {
		case .originalTile: "Título Original"
		case .genersConcatened: "Gênero"
		case .episodesNumber: "Episódios"
		case .yearOfProduction: "Ano de Produção"
		case .country: "País"
		case .directorName: "Direção"
		case .castConcatened: "Elenco"
		}
	}
}

final class TechnicalDetailsViewModel: ObservableObject {
	@Published var items = [AttributedString]()
	let viewData: ContentViewData

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
		case .country(let string): fallthrough
		case .directorName(let string):
			return string

		case .castConcatened(let castNames):
			guard let castNames, !castNames.isEmpty else { return nil }
			return castNames.joined(separator: ", ")
		}
	}

	func updateDetails() async throws {
		var newItems = [TechnicalDetailsItem]()
		newItems.append(.genersConcatened(viewData.content.genreIds))
		await updateItems(with: newItems)
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
