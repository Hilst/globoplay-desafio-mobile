//
//  SuggestionsViewModel.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

import SwiftUI

final class SuggestionsViewModel: ObservableObject {
	@Published var suggestedViewDatas = [ContentViewData]()

	let originalContent: ContentModel

	init(originalContentViewData: ContentViewData) {
		self.originalContent = originalContentViewData.content
	}

	func getSuggestions() async throws {
		 let suggestions = try await RecommendationsRequest(content: originalContent)
			.requestAndTransform()
			.prefix(6)
			.map { ContentViewData(content: $0) }
		await MainActor.run { suggestedViewDatas = Array(suggestions) }
	}
}
