//
//  Network.swift
//  Globoplay
//
//  Created by Felipe Hilst on 21/11/24.
//

import Foundation

enum Network {
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
