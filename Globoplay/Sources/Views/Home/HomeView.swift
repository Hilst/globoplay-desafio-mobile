//
//  HomeView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 20/11/24.
//

import SwiftUI

struct HomeView: View {
	@ObservedObject var viewModel = HomeViewModel()
	@State var madeFetch = false

	var body: some View {
		VStack {
			Header()
			ScrollView(.vertical) {
				VStack(alignment: .leading) {
					ForEach(PresentationType.allCases, id: \.title) { type in
						if let contentsOfType = viewModel.contents[type],
						   !contentsOfType.isEmpty {
							ContentTypeCarrosselView(type: type, contents: contentsOfType)
						}
					}
				}
				.padding(.leading)
				.padding(.bottom)
			}
			.scrollBounceBehavior(.basedOnSize)
			.background(Color(.backgroung))
		}
		.overlay(alignment: .topLeading) {
			activityView()
		}
		.task(id: madeFetch) {
			if !madeFetch {
				try? await viewModel.updateContent()
				madeFetch = true
			}
		}
	}
}

extension HomeView {
	private func activityView() -> some View {
		Group {
			if viewModel.isLoading, viewModel.isEmpty {
				ProgressView()
					.progressViewStyle(.circular)
					.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
			} else if viewModel.isEmpty, !viewModel.isLoading {
				Text("empty.message")
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

extension HomeView {
	private struct Header: View {
		var body: some View {
			HStack {
				Spacer()
				Image(.logo)
					.resizable()
					.aspectRatio(contentMode: .fill)
					.foregroundStyle(.white)
					.frame(width: 200, height: 100)
					.clipped()
				Spacer()
			}
			.background(Color.black)
		}
	}
}

extension HomeView {
	private struct ContentTypeCarrosselView: View {
		let type: PresentationType
		let contents: [ContentViewData]

		var body: some View {
			VStack(alignment: .leading, spacing: 20) {
				Text(type.title)
					.font(.title)
					.fontWeight(.bold)
				ScrollView(.horizontal) {
					LazyHStack(alignment: .center) {
						ForEach(contents, id: \.content.id) { content in
							NavigationLink(value: content) {
								ContentImageView(viewData: content, size: .small)
									.padding(.horizontal, 3)
							}
						}
					}
				}
			}
			.padding(.top, 30)
		}
	}
}
