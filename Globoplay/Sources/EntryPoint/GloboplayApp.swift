//
//  GloboplayApp.swift
//  Globoplay
//
//  Created by Felipe Hilst on 19/11/24.
//

import SwiftUI
import SwiftData

struct GloboplayApp: App {
	var container: ModelContainer = modelContainer()

	init() {
		RequestProviderWrapper.setup(provider: URLSessionRequestProvider())
	}

	var body: some Scene {
		WindowGroup {
			ContentView()
				.environment(\.colorScheme, .dark)
		}
		.modelContainer(container)
	}
}
