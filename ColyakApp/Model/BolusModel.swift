//
//  BolusModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
struct Meal: Codable {
    var userId: Int
    var foodList: [Food]
    var bolus: Bolus
}

enum FoodType: String, Codable {
    case RECEIPT = "RECEIPT"
    case BARCODE = "BARCODE"
}

struct Food: Identifiable, Codable {
    var id = UUID()
    var foodId: Int
    var foodType: FoodType
    var carbonhydrate: Int?
    var foodName: String?
}

struct Bolus: Codable {
    var bloodSugar: Int?
    var targetBloodSugar: Int?
    var insulinTolerateFactor: Int?
    var totalCarbonhydrate: Int?
    var insulinCarbonhydrateRatio: Int?
    var bolusValue: Int?
    var eatingTime: String?
}
