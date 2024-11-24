//
//  MyListView.swift
//  Globoplay
//
//  Created by Felipe Hilst on 22/11/24.
//
import SwiftUI
import SwiftData

struct MyListView: View {
	@Query var contentsSaved: [ContentModel]

	var body: some View {
		VStack {
			Header()
			ScrollView {
				ContentsGridView(viewDatas: contentsSaved.lazy.map {
					ContentViewData(content: $0)
				})
			}
			.padding(.vertical)
			.scrollBounceBehavior(.basedOnSize)
			.background(Color(.backgroung))
			Spacer()
		}
	}
}

extension MyListView {
	private struct Header: View {
		var body: some View {
			HStack {
				Text("list.view.title")
					.foregroundStyle(.white)
					.font(.title)
					.fontWeight(.bold)
					.padding(.top, 40)
					.padding(.bottom, 20)
					.padding(.horizontal, 25)
				Spacer()
			}
		}
	}
}
