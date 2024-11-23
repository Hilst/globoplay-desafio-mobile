//
//  String+Date.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//
import Foundation

extension Date {
	func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
		return calendar.component(component, from: self)
	}
}
