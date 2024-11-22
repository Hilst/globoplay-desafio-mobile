//
//  Array+NonRepeating.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

extension Array where Element: Equatable {
	mutating func nonRepeatingAppend(_ element: Element) {
		if !contains(element) {
			append(element)
		}
	}

	mutating func nonRepeatingAppend(contentsOf elements: [Element]) {
		for element in elements {
			nonRepeatingAppend(element)
		}
	}
}
