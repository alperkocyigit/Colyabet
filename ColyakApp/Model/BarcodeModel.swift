//
//  BarcodeModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
struct Barcode:Decodable,Identifiable{
    let id, code: Int?
    let name: String?
    let imageId: Int?
    let glutenFree, deleted: Bool?
    let nutritionalValuesList: [NutritionalValuesList]?
}

struct nutritionalValuesList:Codable,Identifiable {
    let id, unit: Int?
    let type: String?
    let carbohydrateAmount, proteinAmount, fatAmount, calorieAmount: Int?
}
