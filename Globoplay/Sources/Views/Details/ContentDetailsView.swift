//
//  ContentDetailsView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

import SwiftUI
import SwiftData

struct ContentDetailsView: View {
	let viewData: ContentViewData

	var body: some View {
		ScrollView(.vertical){
			VStack {
				HStack {
					Spacer()
					ContentDetailsHeading(viewData: viewData)
					Spacer()
				}
				ContentDetailsItemsView(viewData: viewData)
					.background(.black)
				Spacer()
			}
			.padding(.top)
		}
		.scrollBounceBehavior(.basedOnSize)
		.background(BackgroundView(viewData: viewData))
		.replaceDismissButton()
	}
}
