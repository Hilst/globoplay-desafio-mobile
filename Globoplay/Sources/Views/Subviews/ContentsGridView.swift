//
//  ContentsGridView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//

import SwiftUI

struct ContentsGridView: View {
	let viewDatas: [ContentViewData]

	let columns = [
		GridItem(.flexible()),
		GridItem(.flexible()),
		GridItem(.flexible()),
	]

	var body: some View {
		ScrollView {
			LazyVGrid(columns: columns, spacing: 20) {
				ForEach(viewDatas, id: \.content.id) { viewData in
					NavigationLink(value: viewData) {
						ContentImageView(viewData: viewData, size: .small)
					}
				}
			}
			.padding(.horizontal)
		}
	}
}
