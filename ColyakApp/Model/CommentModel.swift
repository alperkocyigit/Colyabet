//
//  CommentModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
struct Commentt:Codable {
    let commentId: Int?
    let userName, receiptName, createdDate, comment: String?
}
