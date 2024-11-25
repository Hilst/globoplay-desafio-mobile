//
//  MainEntryPoint.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import SwiftUI
import SwiftData

@main
struct MainEntryPoint {
	static func main() {
#if DEBUG
		guard isNotTest else {
			TestApp.main()
			return
		}
#endif
		GloboplayApp.main()
	}

	static var isNotTest: Bool {
		return NSClassFromString("XCTestCase") == nil
	}
}

#if DEBUG
struct TestApp: App {
	var container = modelContainer()
	var body: some Scene {
		WindowGroup { }
			.modelContainer(container)
	}
}
#endif

func modelContainer() -> ModelContainer {
	let schema = Schema([ContentModel.self])
	let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
	do {
		return try ModelContainer(for: schema, configurations: configuration)
	} catch {
		fatalError("Failed to start container")
	}
}
