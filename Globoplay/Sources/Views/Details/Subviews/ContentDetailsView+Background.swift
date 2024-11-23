//
//  BackgroundDetailsView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//
import SwiftUI

extension ContentDetailsView {
	struct BackgroundView: View {
		let viewData: ContentViewData

		let gradient = LinearGradient(
			gradient: Gradient(stops: [
				.init(color: .clear, location: 0),
				.init(color: .black, location: 0.45),
			]),
			startPoint: .top,
			endPoint: .bottom
		)

		var body: some View {
			AsyncImage(url: viewData.posterURL(size: .all)) { phase in
				if let image = phase.image {
					ZStack {
						image
							.resizable()
							.aspectRatio(contentMode: .fill)
							.blur(radius: 20)
							.clipped()
							.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
						gradient
					}
				} else {
					Color.black
				}
			}
			.ignoresSafeArea(edges: .top)
		}
	}
}
