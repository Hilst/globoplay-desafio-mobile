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

		private var localizationKey: String {
			switch self {
			case .suggestions: "suggestions.picker.value" // "ASSISTA TAMBÉM"
			case .technicalDetails: "techdetails.picker.value" // "DETALHES"
			}
		}

		var title: String { String(localizationKey: self.localizationKey) }

		@ViewBuilder
		func view(viewData: ContentViewData) -> some View {
			switch self {
			case .suggestions:
				SuggestionsView(viewData: viewData)
			case .technicalDetails:
				TechnicalDetailsView(viewData: viewData)
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
