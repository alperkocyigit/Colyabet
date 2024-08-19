//
//  QuizModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
struct Quiz:Codable,Identifiable {
    let id: Int?
    let topicName: String?
    let questionList: [Question]?
    let deleted: Bool?
}

// MARK: - QuestionList
struct Question:Codable,Identifiable {
    let id: Int?
    let question: String?
    let choicesList: [Choice]?
    let correctAnswer: String?
}

// MARK: - ChoicesList
struct Choice:Codable,Identifiable{
    let id: Int?
    let choice: String?
    let imageId: Int?
}
