//
//  RequestProvider.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import Foundation

@testable import Globoplay

final class RequestProviderMock {
	var response: Data? = nil
	var urlResponse = URLResponse()

	private(set) var spyArray = [URLRequest]()

	static let instance = RequestProviderMock()

	private init() { }

	func reset() {
		response = nil
		urlResponse = URLResponse()
		spyArray = []
	}

	static func setup() {
		RequestProviderWrapper.setup(provider: instance)
	}
}

extension RequestProviderMock: RequestProvider {
	func data(for request: URLRequest) async throws -> (Data, URLResponse) {
		spyArray.append(request)
		guard let response else { throw RequestError.invalidURL }
		return (response, urlResponse)
	}
}
