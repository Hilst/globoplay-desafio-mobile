//
//  ArraySlice+toArray.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

extension Sequence {
	func asArray() -> [Element] {
		Array(self)
	}
}
