//
//  ContentDetailsView+DetailsItem.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//

import SwiftUI

extension ContentDetailsItemsView {
	enum DetailsItem: Int, CaseIterable {
		case suggestions, technicalDetails

		var title: String {
			switch self {
			case .suggestions: "ASSISTA TAMBÉM"
			case .technicalDetails: "DETALHES"
			}
		}

		@ViewBuilder
		func view(viewData: ContentViewData) -> some View {
			switch self {
			case .suggestions:
				SuggestionsView(viewData: viewData)
			case .technicalDetails:
				Text(self.title + "content")
				//		func genresDescriptions() -> String {
				//			viewData
				//				.content
				//				.genreIds?
				//				.compactMap { Genres.genresMap[$0] }
				//				.joined(separator: ", ")
				//			?? String()
				//		}
			}
		}

		@ViewBuilder
		func pickerView(_ state: State<Self>) -> some View {
			Button { state.wrappedValue = self }
			label: {
					Group {
						if state.wrappedValue == self {
							Text(self.title)
								.background(
									Color.white
										.frame(height: 2)
										.offset(y: 20)
								)
						} else {
							Text(self.title)
								.foregroundStyle(.gray)
						}
					}
			}
		}
	}
}
