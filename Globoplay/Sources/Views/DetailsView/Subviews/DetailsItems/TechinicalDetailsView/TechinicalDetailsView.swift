//
//  TechinicalDetailsView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

import SwiftUI

struct TechnicalDetailsView: View {
	@ObservedObject var viewModel: TechnicalDetailsViewModel
	@State var madeFetch = false
	init(viewData: ContentViewData) {
		viewModel = TechnicalDetailsViewModel(viewData: viewData)
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text("technical.view.title")
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
		.overlay(alignment: .topLeading) {
			activityView()
		}
		.containerRelativeFrame([.horizontal], alignment: .topLeading)
		.task {
			if !madeFetch {
				try? await viewModel.updateDetails()
				madeFetch = true
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
				Text("techdetails.empty.message")
					.font(.callout)
					.fontWeight(.semibold)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			} else {
				EmptyView()
			}
		}
		.background(Color(.backgroung))
	}
}
