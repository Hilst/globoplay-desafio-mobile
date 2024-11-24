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
				Label("Início", image: .homeIcon)
					.font(.caption)
					.foregroundStyle(.gray)
			}

			NavigationStack {
				MyListView()
					.routeToContentViewDetails()
			}
			.tabItem {
				Label("Minha lista", image: .starIcon)
					.font(.caption)
					.foregroundStyle(.gray)
			}
		}
	}
}
