//
//  ContentDetailsView+Buttons.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//

import SwiftUI
import SwiftData

extension ContentDetailsView {
	struct WatchButton: View {
		var body: some View {
			Button {
				print("assita")
			} label: {
				Label("details.button.watch", image: .playIcon)
					.foregroundStyle(.gray)
			}
			.primary()
		}
	}
}

extension ContentDetailsView {
	struct FavoriteButton: View {
		@Environment(\.modelContext) var context

		let contentModel: ContentModel
		@Query var savedContents: [ContentModel]

		private var isSaved: Bool {
			savedContents
				.map { $0.id }
				.contains(contentModel.id)
		}

		private func buttonAction() {
			isSaved ? context.delete(contentModel) : context.insert(contentModel)
		}

		private func buttonLabel() -> some View {
			Label(
				isSaved ? "details.button.added" : "details.button.add",
				image: isSaved ? .checkIcon : .starIcon
			)
		}

		var body: some View {
			Button(
				action: buttonAction,
				label: buttonLabel
			)
			.primary(stroked: true)
		}
	}
}
