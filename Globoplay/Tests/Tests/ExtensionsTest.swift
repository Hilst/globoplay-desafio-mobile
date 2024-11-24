//
//  ExtensionsTest.swift
//  Globoplay
//
//  Created by Felipe Hilst on 24/11/24.
//

import Foundation

import XCTest

@testable import Globoplay

final class ExtensionsTest: XCTestCase {

	// MARK: - Array+NonRepeating

	func testDontDoubleAppendSingleElement() {
		var array = [ 1, 2, 3]

		array.nonRepeatingAppend(4)
		array.nonRepeatingAppend(4)

		XCTAssertEqual(array, [1, 2, 3, 4])
	}

	func testDontDoubleAppendContentOf() {
		var array = [ 1, 2, 3]

		array.nonRepeatingAppend(contentsOf: [ 1, 3, 5 ])

		XCTAssertEqual(array, [1, 2, 3, 5])
	}

	// MARK: - ArraySubSequence+toArray

	func testSubSequenceArrayConvertion() {
		let original = [1, 2, 3, 4]
		let subsequence = original.dropLast()

		let newArray = subsequence.asArray()

		XCTAssertFalse((subsequence as Any) is Array<Int>)
		XCTAssertTrue((newArray as Any) is Array<Int>)
	}

	// MARK: - Date+Component

	func testDateGomponentGet() {
		let dateString = "2000-01-01"
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY-MM-dd"
		let date = formatter.date(from: dateString)!

		let day = date.get(.day)
		let month = date.get(.month)
		let year = date.get(.year)

		XCTAssertEqual(day, 1)
		XCTAssertEqual(month, 1)
		XCTAssertEqual(year, 2000)
	}

	// MARK: - String+Plural

	func testStringRemovePlural() {
		let plural = "apples"

		XCTAssertTrue(plural.isSimplePlural())

		let singular = plural.asSimpleSingular()

		XCTAssertFalse(singular.isSimplePlural())
		XCTAssertEqual(singular, "apple")
	}
}
