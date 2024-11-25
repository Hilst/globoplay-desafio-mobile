//
//  RequestProtocol.swift
//  Globoplay
//
//  Created by Felipe Hilst on 25/11/24.
//

import Foundation

protocol Request {
	associatedtype ReturnType: Decodable
	var path: [String]? { get }
	var addtionalQuery: [String: String]? { get }
	var method: RequestMethod { get }
	var timeout: Double { get }
	var isContentJson: Bool { get }
	var decoder: JSONDecoder { get }
	func request(withProvider provider: RequestProvider) async throws -> ReturnType
}

protocol RequestWithTransformation: Request {
	associatedtype TransformationResult
	func transformation(_ returned: ReturnType) -> TransformationResult
	func requestAndTransform(withProvider provider: RequestProvider) async throws -> TransformationResult
}

extension Request {
	var path: [String]? { nil }
	var additionalQuery: [String: String]? { nil }
	var method: RequestMethod { .GET }
	var timeout: Double { 10.0 }
	var decoder: JSONDecoder {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}
}

extension Request {
	func request(
		withProvider provider: RequestProvider = RequestProviderWrapper().wrappedValue
	) async throws -> ReturnType {
		var stringURL = Network.Constants.baseURL
		if let path = path, !path.isEmpty {
			stringURL += "/" + path.joined(separator: "/")
		}

		guard let url = URL(string: stringURL),
			  var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
		else { throw RequestError.invalidURL }

		var queryItems: [URLQueryItem] = [
			URLQueryItem(name: Network.Constants.ApiKey.key, value: Secrets.apiKey),
			URLQueryItem(name: Network.Constants.Language.key, value: Network.Constants.Language.value),
		]
		let parsedQueryItems = addtionalQuery?.map {
			key, value in
			URLQueryItem(name: key, value: value)
		} ?? []
		queryItems.append(contentsOf: parsedQueryItems)
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

		var urlRequest = URLRequest(url: components.url!)
		urlRequest.httpMethod = method.rawValue
		urlRequest.timeoutInterval = timeout
		if isContentJson {
			urlRequest.allHTTPHeaderFields = ["accept": "application/json"]
		}

		do {
			let (data, _) = try await provider.data(for: urlRequest)
			#if DEBUG
			print(String(decoding: data, as: UTF8.self))
			#endif
			return try decoder.decode(ReturnType.self, from: data)
		} catch (let error) {
			debugPrint(self, error)
			throw error
		}
	}
}

extension RequestWithTransformation {
	func requestAndTransform(
		withProvider provider: RequestProvider = RequestProviderWrapper().wrappedValue
	) async throws -> TransformationResult {
		let returned = try await request(withProvider: provider)
		return transformation(returned)
	}
}
