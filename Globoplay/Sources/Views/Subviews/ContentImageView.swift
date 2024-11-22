//
//  ContentImageView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

import SwiftUI

struct ContentImageView: View {
	let viewData: ContentViewData
	let size: PosterSize

	var body: some View {
		AsyncImage(url: viewData.posterURL(size: size)) { phase in
			if let image = phase.image {
				image.resizable()
			} else if phase.error != nil {
				PlaceholderView(text: viewData.title)
			} else {
				LoadingView()
			}
		}
		.frame(width: size.frame.w, height: size.frame.h)
	}
}

extension ContentImageView {
	private struct PlaceholderView: View {
		let text: String

		var body: some View {
			ZStack {
				Rectangle()
					.foregroundStyle(.gray, .background)
				VStack(spacing: 5) {
					Image(systemName: "movieclapper.fill")
					Text(text)
						.font(.caption)
						.multilineTextAlignment(.center)
				}
			}
		}
	}

	private struct LoadingView: View {
		var body: some View {
			ZStack {
				Rectangle()
					.foregroundStyle(.gray, .background)
				ProgressView()
			}
		}
	}
}
