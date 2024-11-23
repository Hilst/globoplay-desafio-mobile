//
//  TechinicalDetailsView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

import SwiftUI

struct TechnicalDetailsView: View {
	@ObservedObject var viewModel: TechnicalDetailsViewModel
	init(viewData: ContentViewData) {
		viewModel = TechnicalDetailsViewModel(viewData: viewData)
	}

	var body: some View {
		VStack(alignment: .leading) {
			Text("Ficha técnica")
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
		.containerRelativeFrame([.horizontal], alignment: .topLeading)
		.task {
			try? await viewModel.updateDetails()
		}
	}
}
