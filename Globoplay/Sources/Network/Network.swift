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
			static let value = "pt-BR"
		}
		static let globoplayCompaniesIdsQuery = "79744|13969|186381|195816|193977|201057|201059|179074|192377|203962|46430|222282|229042|233438|205328|195815|181914|7462|196151|181587|206373"
	}
}

enum RequestMethod: String {
	case GET, POST
}

protocol Request {
	var path: [String]? { get }
	var addtionalQuery: [String: String]? { get }
	var method: RequestMethod { get }
	var timeout: Double { get }
	var isContentJson: Bool { get }
}

extension Request {
	var path: [String]? { nil }
	var additionalQuery: [String: String]? { nil }
	var method: RequestMethod { .GET }
	var timeout: Double { 10.0 }
}

extension Network {
	enum RequestError: Error {
		case invalidURL
	}

	private static let baseURL = "https://api.themoviedb.org/3"
	static func request(_ request: Request) async throws -> Data {
		var stringURL = baseURL
		if let path = request.path, !path.isEmpty {
			stringURL += "/" + path.joined(separator: "/")
		}

		guard let url = URL(string: stringURL),
			  var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
		else { throw RequestError.invalidURL }

		var queryItems: [URLQueryItem] = [
			URLQueryItem(name: Network.Constants.ApiKey.key, value: Secrets.apiKey),
			URLQueryItem(name: Network.Constants.Language.key, value: Network.Constants.Language.value),
		]
		let parsedQueryItems = request.addtionalQuery?.map {
			key, value in
			URLQueryItem(name: key, value: value)
		} ?? []
		queryItems.append(contentsOf: parsedQueryItems)
		components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

		var urlRequest = URLRequest(url: components.url!)
		urlRequest.httpMethod = request.method.rawValue
		urlRequest.timeoutInterval = request.timeout
		if request.isContentJson {
			urlRequest.allHTTPHeaderFields = ["accept": "application/json"]
		}

		let (data, _) = try await URLSession.shared.data(for: urlRequest)
		return data
	}
}
