//
//  Destinations.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//
import SwiftUI

struct ContentViewDataDestination: ViewModifier {
	func body(content: Content) -> some View {
		content
			.navigationDestination(for: ContentViewData.self) { viewData in
				ContentDetailsView(viewData: viewData)
			}
	}
}

extension View {
	func routeToContentViewDetails() -> some View {
		modifier(ContentViewDataDestination())
	}
}
