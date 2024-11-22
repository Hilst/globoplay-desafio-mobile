//
//  HomeView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 20/11/24.
//

import SwiftUI

struct HomeView: View {
	@ObservedObject var viewModel = HomeViewModel()
	
	var body: some View {
		ScrollView(.vertical) {
			VStack(alignment: .leading) {
				ForEach(PresentationType.allCases, id: \.title) { type in
					if let contentsOfType = viewModel.contents[type] {
						ContentTypeCarrosselView(type: type,
												 contents: contentsOfType)
					}
				}
			}
		}
		.task {
			try? await viewModel.updateContent()
		}
		.background(Color(.backgroung))
	}
}

extension HomeView {
	private struct ContentTypeCarrosselView: View {
		let type: PresentationType
		let contents: [ContentViewData]

		var body: some View {
			VStack(alignment: .leading, spacing: 10) {
				Text(type.title)
					.font(.title)
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
		}
	}
}
