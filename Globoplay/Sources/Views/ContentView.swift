//
//  ContentView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 19/11/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	init() {
		UITabBar.appearance().backgroundColor = .black
	}

    var body: some View {
		TabView {
			NavigationStack {
				HomeView()
			}
			.tabItem {
				Label("Início", systemImage: "house.fill")
					.font(.caption2)
			}

			NavigationStack {
				MyListView()
			}
			.tabItem {
				Label("Minha lista", systemImage: "star.fill")
					.font(.caption2)
			}
		}
    }
}

struct MyListView: View {
	@Environment(\.modelContext) var context

	@Query var contentsSaved: [ContentModel]

	var body: some View {
		List {
			ForEach(contentsSaved, id: \.id) { content in
				ContentImageView(content: ContentViewData(content: content), size: .small)
			}
		}
	}
}
