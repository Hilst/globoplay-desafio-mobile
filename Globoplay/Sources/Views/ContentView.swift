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
				Label("Início", systemImage: "house.fill")
					.font(.caption2)
			}

			NavigationStack {
				MyListView()
					.routeToContentViewDetails()
			}
			.tabItem {
				Label("Minha lista", systemImage: "star.fill")
					.font(.caption2)
			}
		}
	}
}
