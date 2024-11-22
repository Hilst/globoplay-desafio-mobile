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
				Label("Assista", systemImage: "play.fill")
			}
			.primary()
		}
	}
}

extension ContentDetailsView {
	struct FavoriteButton: View {
		typealias FavoriteButtonType = Button<Label<Text, Image>>
		@Environment(\.modelContext) var context

		let contentModel: ContentModel
		@Query var savedContents: [ContentModel]

		private var isSaved: Bool {
			savedContents
				.map { $0.id }
				.contains(contentModel.id)
		}

		private func InListButton() -> FavoriteButtonType {
			Button {
				context.delete(contentModel)
			} label: {
				Label("Adicionado", systemImage: "checkmark")
			}
		}

		private func AddListButton() -> FavoriteButtonType {
			Button {
				context.insert(contentModel)
			} label: {
				Label("Minha lista", systemImage: "star.fill")
			}
		}

		var body: some View {
			let buttonBuilder = isSaved ? InListButton : AddListButton
			buttonBuilder()
				.primary(stroked: true)
		}
	}
}
