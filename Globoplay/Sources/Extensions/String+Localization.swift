//
//  String+Localization.swift
//  Globoplay
//
//  Created by Felipe Hilst on 24/11/24.
//

extension String {
	init(localizationKey: String) {
		let key = String.LocalizationValue(localizationKey)
		self.init(localized: key)
	}
}
