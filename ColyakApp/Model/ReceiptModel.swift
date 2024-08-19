//
//  ReceiptModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
struct Receipt: Identifiable, Decodable,Equatable,Encodable {
    static func == (lhs: Receipt, rhs: Receipt) -> Bool {
        return lhs.receiptName == rhs.receiptName
    }
    let id: Int
    let receiptDetails: [String]?
    let receiptItems: [ReceiptItem]?
    let receiptName: String?
    let nutritionalValuesList:[NutritionalValuesList]?
    let imageId: Int?
   
}

struct ReceiptItem: Identifiable, Decodable , Encodable {
    let id: Int
    let productName: String?
    let unit: Double?
    let type: String?
}


struct NutritionalValuesList: Identifiable, Decodable,Encodable {
    let id: Int
    let unit: Int?
    let type: String?
    let carbohydrateAmount: Double?
    let proteinAmount: Double?
    let fatAmount: Double?
    let calorieAmount:Double?
}

