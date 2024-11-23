//
//  ContentViewData.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

import Foundation

enum PosterSize: String {
	case small = "w185"
	case big = "w342"
	case all = "w780"

	var frame: (w: CGFloat, h: CGFloat) {
		switch self {
		case .small: (w: 106, h: 160)
		case .big: (w: 200, h: 301)
		case .all: (w: .infinity, h: .infinity)
		}
	}
}

struct ContentViewData: Hashable {
	let content: ContentModel
	let title: String
	private let posterPath: String?
	let presentationTitle: String?

	init(content: ContentModel) {
		self.content = content
		self.title = content.title ?? String()
		self.posterPath = content.posterPath
		let typeId = content.presentation
		var type: PresentationType? = nil
		if let typeId {
			type = PresentationType(rawValue: typeId)
		}
		self.presentationTitle = type?.title
	}

	func posterURL(size: PosterSize) -> URL? {
		guard let posterPath = content.posterPath else { return nil }
		return URL(string: "https://image.tmdb.org/t/p/\(size.rawValue)\(posterPath)")
	}
}

extension ContentViewData: Equatable {
	static func == (lhs: ContentViewData, rhs: ContentViewData) -> Bool {
		lhs.content.id == rhs.content.id
	}
}
