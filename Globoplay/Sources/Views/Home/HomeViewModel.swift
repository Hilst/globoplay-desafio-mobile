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
}

final class HomeViewModel: ObservableObject {

	@Published var contents: [PresentationType: [ContentViewData]] = emptyContents()

	private static func emptyContents() -> [PresentationType: [ContentViewData]] {
		[.movie: [], .soap: [], .tvshow: []]
	}

	func updateContent() async throws {
		var presentations: [PresentationType: [ContentViewData]] = Self.emptyContents()

		let returnedMovies = try await DiscoverRequest(type: .movie)
			.request()
			.results
			.lazy.map { ContentModel(dto: $0) }
		returnedMovies.forEach { movie in
			movie.presentationTitle = PresentationType.movie.title
			presentations[.movie]?.nonRepeatingAppend(ContentViewData(content: movie))
		}

		let returnTVShows = try await DiscoverRequest(type: .tv)
			.request()
			.results
			.lazy.map { ContentModel(dto: $0) }
		returnTVShows.forEach { tvShow in
			let type: PresentationType = tvShow.isSoap ? .soap : .tvshow
			tvShow.presentationTitle = type.title
			presentations[type]?.nonRepeatingAppend(ContentViewData(content: tvShow))
		}

		let merged = contents.merging(presentations) { current, new in
				var current = current
				current.nonRepeatingAppend(contentsOf: new)
				return current
		}

		await MainActor.run { contents = merged }
	}
}
