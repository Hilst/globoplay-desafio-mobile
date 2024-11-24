//
//  OnRotateModifier.swift
//  Globoplay
//
//  Created by Felipe Hilst on 24/11/24.
//

import SwiftUI

extension View {
	func onRotate(
		_ onRotate: @escaping (UIDeviceOrientation) -> Void,
		onAppear: (() -> Void)? = nil
	) -> some View {
			modifier(DeviceRotationModifier(onAppearPerform: onAppear, onRotatePerform: onRotate))
	}
}

struct DeviceRotationModifier: ViewModifier {
	let onAppearPerform: (() -> Void)?
	let onRotatePerform: (UIDeviceOrientation) -> Void
	func body(content: Content) -> some View {
		content
			.onAppear(perform: onAppearPerform)
			.onReceive(
				NotificationCenter
					.default
					.publisher(for: UIDevice.orientationDidChangeNotification)
			) { _ in
				onRotatePerform(UIDevice.current.orientation)
			}
	}
}
