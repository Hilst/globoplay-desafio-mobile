//
//  GloboplayApp.swift
//  Globoplay
//
//  Created by Felipe Hilst on 19/11/24.
//

import SwiftUI
import SwiftData

@main
struct GloboplayApp: App {
	var container: ModelContainer = {
		let schema = Schema([ContentModel.self])
		let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
		do {
			return try ModelContainer(for: schema, configurations: configuration)
		} catch {
			fatalError("Failed to start container")
		}
	}()

    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.colorScheme, .dark)
        }
		.modelContainer(container)
    }
}
