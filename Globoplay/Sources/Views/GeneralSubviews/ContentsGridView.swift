//
//  ContentsGridView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//

import SwiftUI

struct ContentsGridView: View {
	let viewDatas: [ContentViewData]

	@State private var columns = [GridItem](repeating: GridItem(.flexible()),
											count: 3)

	private func updateGridItemsSize(
		orientation: UIDeviceOrientation = UIDevice.current.orientation
	) {
		let current = columns.count
		var itemInARow = current
		switch orientation {
		case .landscapeLeft: fallthrough
		case .landscapeRight:
			itemInARow = 6
		case .portrait:
			itemInARow = 3
		default:
			break
		}
		columns = [GridItem](repeating: GridItem(.flexible()),
							 count: itemInARow)
	}

	var body: some View {
			LazyVGrid(columns: columns, spacing: 20) {
				ForEach(viewDatas, id: \.content.id) { viewData in
					NavigationLink(value: viewData) {
						ContentImageView(viewData: viewData, size: .small)
					}
				}
			}
			.onRotate { _ in
				updateGridItemsSize()
			}
			.padding(.horizontal)
	}
}
