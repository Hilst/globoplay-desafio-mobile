//
//  ReplaceDismissButtonModifier.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

import SwiftUI

extension View {
	func replaceDismissButton() -> some View {
		modifier(ReplaceDismissButton())
	}
}

struct ReplaceDismissButton: ViewModifier {
	struct DismissButton: View {
		@Environment(\.dismiss) var dismiss
		var body: some View {
			Button {
				dismiss()
			} label: {
				Image(systemName: "arrow.left")
			}
		}
	}

	func body(content: Content) -> some View {
		content
			.toolbar(.hidden, for: .tabBar)
			.navigationBarBackButtonHidden()
			.toolbar {
				ToolbarItem(placement: .topBarLeading) {
					DismissButton()
				}
			}
	}
}
