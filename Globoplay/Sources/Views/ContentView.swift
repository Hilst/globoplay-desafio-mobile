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
					.navigationDestination(for: ContentViewData.self) { viewData in
						ContentDetailsView(viewData: viewData)
					}
			}
			.tabItem {
				Label("Início", systemImage: "house.fill")
					.font(.caption2)
			}

			NavigationStack {
				MyListView()
					.navigationDestination(for: ContentViewData.self) { viewData in
						ContentDetailsView(viewData: viewData)
					}
			}

			.tabItem {
				Label("Minha lista", systemImage: "star.fill")
					.font(.caption2)
			}
		}
	}
}

struct MyListView: View {
	@Query var contentsSaved: [ContentModel]

	var body: some View {
		ContentsGridView(viewDatas: contentsSaved.lazy.map {
			ContentViewData(content: $0)
		})
	}
}

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
