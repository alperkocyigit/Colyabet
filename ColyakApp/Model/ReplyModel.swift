//
//  ReplyModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

struct Replly:Codable{
    let replyId: Int?
    let userName, createdDate, reply: String?
}
