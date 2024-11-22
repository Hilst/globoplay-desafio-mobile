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
		ContentsGridView(viewDatas: contentsSaved.lazy.map {
			ContentViewData(content: $0)
		})
	}
}
