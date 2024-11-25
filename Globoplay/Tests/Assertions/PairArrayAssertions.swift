//
//  PairArrayAssertions.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import XCTest

@testable import Globoplay

extension XCTestCase {
	func pairArray<T>(_ value: T, _ expected: T) -> [T] where T: Equatable {
		return [value, expected]
	}
}

extension Array where Element: Equatable {
	func assertPair(_ message: String? = nil) {
		guard self.count == 2 else {
			XCTFail("Can only compare pairs")
			return
		}

		let first = self[0]
		let second = self[1]
		if let message {
			XCTAssertEqual(first, second, message)
		} else {
			XCTAssertEqual(first, second)
		}
	}
}

extension Array where Element == ContentModel  {
	func assert(_ messagePrefix: String? = nil) {
		let messagePrefix = messagePrefix ?? "ContentModel:"
		self.map { $0.id }.assertPair("\(messagePrefix) ids")
		self.map { $0.title }.assertPair("\(messagePrefix) titles")
		self.map { $0.originalTitle }.assertPair("\(messagePrefix) original tiles")
		self.map { $0.originalLanguage }.assertPair("\(messagePrefix) original languages")
		self.map { $0.overview }.assertPair("\(messagePrefix) overviews")
		self.map { $0.releaseDate }.assertPair("\(messagePrefix) release dates")
		self.map { $0.genreIds }.assertPair("\(messagePrefix) genres ids")
		self.map { $0.posterPath }.assertPair("\(messagePrefix) poster paths")
	}
}
