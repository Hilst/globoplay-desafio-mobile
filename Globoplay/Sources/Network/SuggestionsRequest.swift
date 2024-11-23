//
//  SuggestionsRequest.swift
//  Globoplay
//
//  Created by Felipe Hilst on 23/11/24.
//

struct RecommendationsRequest: RequestWithTransformation {

	var addtionalQuery: [String : String]?
	
	typealias ReturnType = ContentWrapper

	let content: ContentModel

	var path: [String]? {
		let typeId = content.presentation ?? PresentationType.movie.rawValue
		let type = PresentationType(rawValue: typeId) ?? .movie
		return [
			type.apiString,
			content.id.description,
			"recommendations"
		]
	}
	let isContentJson: Bool = true

	typealias TransformationResult = [ContentModel]
	func transformation(_ returned: ContentWrapper) -> [ContentModel] {
		returned
			.results
			.compactMap {
				let model = ContentModel(dto: $0)
				model.presentation = Self.newPresentation(newModel: model)?.rawValue
				guard model.originalLanguage == "pt" else { return nil }
				return model
			}
	}

	private static func newPresentation(newModel model: ContentModel) -> PresentationType? {
		guard !model.isSoap else { return .soap }
		guard let originTypeId = model.presentation,
			  let type = PresentationType(rawValue: originTypeId)
		else { return nil }
		return type
	}
}
