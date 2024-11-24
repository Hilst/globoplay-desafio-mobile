//
//  ContentView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 19/11/24.
//

import SwiftUI

struct ContentView: View {
	init() {
		UITabBar.appearance().backgroundColor = .black
	}

	var body: some View {
		TabView {
			NavigationStack {
				HomeView()
					.routeToContentViewDetails()
			}
			.tabItem {
				Label("home.toolbar.item", image: .homeIcon)
					.font(.caption)
					.foregroundStyle(.gray)
			}

			NavigationStack {
				MyListView()
					.routeToContentViewDetails()
			}
			.tabItem {
				Label("list.toolbar.item", image: .starIcon)
					.font(.caption)
					.foregroundStyle(.gray)
			}
		}
	}
}
