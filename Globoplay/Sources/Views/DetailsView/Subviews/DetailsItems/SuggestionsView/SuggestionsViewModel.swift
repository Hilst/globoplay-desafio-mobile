//
//  SuggestionsViewModel.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

import SwiftUI

final class SuggestionsViewModel: ObservableObject {
	@Published var suggestedViewDatas = [ContentViewData]()
	@Published var isLoading = true
	@Published var isEmpty = true

	let originalContent: ContentModel

	init(originalContentViewData: ContentViewData) {
		self.originalContent = originalContentViewData.content
	}

	func getSuggestions() async throws {
		await MainActor.run { isLoading = true }

		let suggestions = try? await RecommendationsRequest(content: originalContent)
			.requestAndTransform()
			.prefix(6)
			.map { ContentViewData(content: $0) }
			.asArray()

		await MainActor.run {
			suggestedViewDatas = suggestions ?? []
			isEmpty = suggestedViewDatas.isEmpty
			isLoading = false
		}
	}
}
