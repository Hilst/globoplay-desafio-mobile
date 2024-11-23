//
//  SugggestionsView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

import SwiftUI


struct SuggestionsView: View {
	@ObservedObject var viewModel: SuggestionsViewModel

	init(viewData: ContentViewData) {
		viewModel = SuggestionsViewModel(originalContentViewData: viewData)
	}

	var body: some View {
		ContentsGridView(viewDatas: viewModel.suggestedViewDatas)
		.task {
			try? await viewModel.getSuggestions()
		}
	}
}
