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
		var presentations: [PresentationType: [ContentViewData]] = Self.emptyContents()

		async let returnedMovies = try await DiscoverRequest(type: .movie)
			.request()
			.results
			.lazy.map { ContentModel(dto: $0) }
		try await returnedMovies.forEach { movie in
			movie.presentationTitle = PresentationType.movie.title
			presentations[.movie]?.nonRepeatingAppend(ContentViewData(content: movie))
		}

		async let returnTVShows = try await DiscoverRequest(type: .tvshow)
			.request()
			.results
			.lazy.map { ContentModel(dto: $0) }
		try await returnTVShows.forEach { tvShow in
			tvShow.presentationTitle = PresentationType.tvshow.title
			presentations[.tvshow]?.nonRepeatingAppend(ContentViewData(content: tvShow))
		}

		async let returnSoap = try await DiscoverRequest(type: .soap)
			.request()
			.results
			.lazy.map { ContentModel(dto: $0) }
		try await returnSoap.forEach { tvShow in
			tvShow.presentationTitle = PresentationType.soap.title
			presentations[.soap]?.nonRepeatingAppend(ContentViewData(content: tvShow))
		}

		allContents = try await withThrowingTaskGroup(of: [ContentModel])

		let merged = contents.merging(presentations) { current, new in
				var current = current
				current.nonRepeatingAppend(contentsOf: new)
				return current
		}

		await MainActor.run { contents = merged }
	}
}
