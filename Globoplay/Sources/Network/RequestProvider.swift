//
//  RequestProvider.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import Foundation

protocol RequestProvider {
	func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

@propertyWrapper
struct RequestProviderWrapper {

	private static var provider: RequestProvider?

	init() { }

	var wrappedValue: RequestProvider {
		guard let provider = Self.provider else {
			fatalError("Need to provide a RequestProvider with RequestProviderWrapper.setup(provider:)")
		}
		return provider
	}

	static func setup(provider: RequestProvider) {
		if Self.provider == nil {
			Self.provider = provider
		}
	}
}

struct URLSessionRequestProvider: RequestProvider {
	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		try await URLSession.shared.data(for: request)
	}
}
