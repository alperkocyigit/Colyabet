//
//  SuggestionModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

struct Suggestion:Codable {
    var suggestion:String
}

struct SuggestionResponse:Codable {
    let suggestionId: Int?
    let suggestion, userName, createdDate: String?
}
