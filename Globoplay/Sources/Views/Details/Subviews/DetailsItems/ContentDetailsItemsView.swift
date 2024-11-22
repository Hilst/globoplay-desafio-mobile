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
		HStack(alignment: .firstTextBaseline, spacing: 30) {
			ForEach(DetailsItem.allCases, id: \.rawValue) { tabitem in
				tabitem.pickerView(_selectedTab)
			}
			Spacer()
		}
		.padding(.horizontal)
		selectedTab.view(viewData: viewData)
	}
}
