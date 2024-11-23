//
//  HomeViewModel.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

import SwiftUI

enum PresentationType: CaseIterable, Hashable, Equatable {
	static let soapGenreId = 10766

	case soap
	case tvshow
	case movie

	var title: String {
		switch self {
		case .soap: "Novelas"
		case .tvshow: "Séries"
		case .movie: "Cinema"
		}
	}

	var apiString: String {
		switch self {
		case .soap: "tv"
		case .tvshow: "tv"
		case .movie: "movie"
		}
	}
}

final class HomeViewModel: ObservableObject {

	@Published var contents: [PresentationType: [ContentViewData]] = emptyContents()

	private static func emptyContents() -> [PresentationType: [ContentViewData]] {
		[.movie: [], .soap: [], .tvshow: []]
	}

	func updateContent() async throws {
		var newContents = Self.emptyContents()
		try await saveContents(ofType: .movie, in: &newContents)
		try await saveContents(ofType: .tvshow, in: &newContents)
		try await saveContents(ofType: .soap, in: &newContents)
		let merged = contents.merging(newContents) { current, new in
			var current = current
			current.nonRepeatingAppend(contentsOf: new)
			return current
		}

		await MainActor.run { contents = merged }
	}

	private func saveContents(
		ofType type: PresentationType,
		in contentsMap: inout [PresentationType: [ContentViewData]]
	) async throws {
		async let contents = try await DiscoverRequest(type: type)
			.request()
			.results
			.map { ContentModel(dto: $0) }
			.map { ContentViewData(content: $0) }
		try await contentsMap[type]?.nonRepeatingAppend(contentsOf: contents)
	}
}
