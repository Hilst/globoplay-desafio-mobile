//
//  ContentDetailsView+Heading.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//
import SwiftUI

extension ContentDetailsView {
	struct ContentDetailsHeading: View {
		let viewData: ContentViewData

		var body: some View {
			VStack(alignment: .center, spacing: 5) {
				ContentHeaderText(viewData: viewData)
				HStack(alignment: .center, spacing: 10) {
					WatchButton()
					FavoriteButton(contentModel: viewData.content)
				}
			}
		}
	}

	private struct ContentHeaderText: View {
		let viewData: ContentViewData

		func genresDescriptions() -> String {
			viewData
				.content
				.genreIds?
				.compactMap { Genres.genresMap[$0] }
				.joined(separator: ", ")
			?? String()
		}
		
		var body: some View {
			ContentImageView(content: viewData, size: .big)
				.padding(.bottom)
			Text(viewData.title)
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundStyle(.white)
			Text(genresDescriptions())
				.font(.caption)
				.fontWeight(.semibold)
				.foregroundStyle(.gray)
				.padding(.bottom, 10)
			if let overview = viewData.content.overview {
				Text(overview)
					.lineLimit(3)
					.truncationMode(.tail)
					.padding(.bottom, 10)
			}
		}
	}
}

