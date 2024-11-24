//
//  ContentDetailsItems.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//

import SwiftUI

struct ContentDetailsItemsView: View {
	@State private var selectedTab: DetailsItem = .suggestions

	let viewData: ContentViewData

	var body: some View {
		VStack {
			HStack(alignment: .firstTextBaseline, spacing: 30) {
				ForEach(DetailsItem.allCases, id: \.rawValue) { tabitem in
					tabitem.pickerView(_selectedTab)
				}
				.padding(.vertical, 20)
				.padding(.horizontal)
				Spacer()
			}
			selectedTab.view(viewData: viewData)
				.padding(.vertical)
				.background(Color(.backgroung))
		}
	}
}
