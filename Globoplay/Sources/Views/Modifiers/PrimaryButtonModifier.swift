//
//  PrimaryButtonModifier.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//

import SwiftUI

struct PrimaryButtonModifier: ViewModifier {
	let stroke: Bool

	private let BaseRectangle =
	RoundedRectangle(
		cornerRadius: 3,
		style: .continuous
	)

	@ViewBuilder
	private func Background() -> some View {
		if stroke {
			BaseRectangle.stroke()
		} else {
			BaseRectangle
		}
	}

	func body(content: Content) -> some View {
		content
			.frame(width: 170, height: 50)
			.font(.callout)
			.fontWeight(.bold)
			.foregroundStyle(.tint)
			.background(Background())
			.tint(.gray)
	}
}

extension Button {
	func primary(stroked: Bool = false) -> some View {
		modifier(PrimaryButtonModifier(stroke: stroked))
	}
}

