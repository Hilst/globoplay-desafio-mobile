//
//  Network.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

import Foundation

final class Network {
	enum Constants {
		enum ApiKey {
			static let key = "api_key"
		}
		enum Language {
			static let key = "language"
			static var value = { String(localizationKey: "api.language.id") }()
		}
		static let globoplayCompaniesIdsQuery = "79744|13969|186381|195816|193977|201057|201059|179074|192377|203962|46430|222282|229042|233438|205328|195815|181914|7462|196151|181587|206373"
		static let baseURL = "https://api.themoviedb.org/3"
	}
}

enum RequestMethod: String {
	case GET, POST
}

enum RequestError: Error {
	case invalidURL, requestError(Error), decodeError(Error)
}

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
	func requestAndTransform() async throws -> TransformationResult
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
	func requestAndTransform() async throws -> TransformationResult {
		let returned = try await request()
		return transformation(returned)
	}
}
