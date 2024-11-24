//
//  SugggestionsView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

import SwiftUI


struct SuggestionsView: View {
	@ObservedObject var viewModel: SuggestionsViewModel
	@State var madeFetch = false

	init(viewData: ContentViewData) {
		viewModel = SuggestionsViewModel(originalContentViewData: viewData)
	}

	var body: some View {
		ContentsGridView(viewDatas: viewModel.suggestedViewDatas)
			.overlay(alignment: .topLeading) {
				activityView()
			}
			.task {
				if !madeFetch {
					try? await viewModel.getSuggestions()
				}
			}
	}

	private func activityView() -> some View {
		Group {
			if viewModel.isLoading, viewModel.isEmpty {
				ProgressView()
					.progressViewStyle(.circular)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			} else if viewModel.isEmpty, !viewModel.isLoading {
				VStack {
					Spacer()
					Text("suggestions.empty.message")
						.font(.callout)
						.fontWeight(.semibold)
						.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
					Spacer()
				}
			} else {
				EmptyView()
			}
		}
		.background(Color(.backgroung))
	}
}
