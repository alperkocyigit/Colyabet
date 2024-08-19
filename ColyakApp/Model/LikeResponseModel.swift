//
//  LikeResponseModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
struct LikeResponse:Codable {
    let receiptName: String
    let userName : String
    let userId : Int
    let receiptId : Int
}
