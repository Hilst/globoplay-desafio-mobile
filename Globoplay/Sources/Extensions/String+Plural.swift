//
//  String+.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

extension String {
	func isSimplePlural() -> Bool {
		guard let last = self.last else { return false }
		return last == "s"
	}

	func asSimpleSingular() -> String {
		guard isSimplePlural() else { return self }
		return String(self.dropLast())
	}
}
