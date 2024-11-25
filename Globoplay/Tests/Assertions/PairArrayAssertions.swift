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

	func zipPair() -> [[Element.Element]] where Element: Sequence {
		guard self.count == 2 else {
			XCTFail("Can only compare pairs")
			return []
		}

		let first = self[0]
		let second = self[1]
		return zip(first, second).map { [$0.0, $0.1] }
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

extension Array where Element == URLRequest {
	func assert(_ messagePrefix: String? = nil) {
		let messagePrefix = messagePrefix ?? "URLRequest:"
		let components = self.compactMap { $0.url }.compactMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
		components.map { $0.scheme }.assertPair("\(messagePrefix) schema")
		components.map { $0.host }.assertPair("\(messagePrefix) host")
		components.map { $0.path }.assertPair("\(messagePrefix) path")
		components
			.map { $0.queryItems?.sorted(by: { $0.name > $1.name }) ?? [] }
			.zipPair()
			.forEach { itemPair in
				itemPair.map { $0.name }.assertPair("query item name")
				itemPair.map { $0.value }.assertPair("query item value")
			}
		self.compactMap { $0.httpMethod }.assertPair("\(messagePrefix) method")
		self.compactMap { $0.allHTTPHeaderFields }.assertPair("\(messagePrefix) headers")
	}

}
