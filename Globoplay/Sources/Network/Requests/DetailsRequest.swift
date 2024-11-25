//
//  DetailsRequest.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

struct DetailsRequest: RequestWithTransformation {
	typealias ReturnType = DetailsDTO

	let content: ContentModel

	var path: [String]? {
		let typeId = content.presentation ?? PresentationType.movie.rawValue
		let type = PresentationType(rawValue: typeId) ?? .movie
		return [
			type.apiString,
			content.id.description
		]
	}

	let addtionalQuery: [String : String]? = [ "append_to_response": "credits" ]
	let isContentJson: Bool = true

	typealias TransformationResult = DetailsModel
	func transformation(_ returned: DetailsDTO) -> DetailsModel {
		DetailsModel(dto: returned)
	}
}
