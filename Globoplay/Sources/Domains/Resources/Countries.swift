//
//  Countries.swift
//  Globoplay
//
//  Created by Felipe Hilst on 24/11/24.
//

fileprivate struct Country: Decodable, Hashable {
	let iso_3166_1: String
	let native_name: String
}

struct Countries {
	static let countriesMap: [String: String] = {
		let setCountries = Self.loadCountries()
		return Dictionary(uniqueKeysWithValues: setCountries.lazy.map { ($0.iso_3166_1, $0.native_name) })
	}()

	private static func loadCountries() -> Set<Country> {
		let countries: [Country] = ResourcesJSONReader.read(resource: .countries) ?? []
		return Set(countries)
	}
}
