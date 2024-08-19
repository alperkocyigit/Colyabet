//
//  UserReportModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
struct UserReport: Codable, Identifiable {
    var id = UUID()
    var userName: String?
    var foodResponseList: [FoodResponse]?
    var bolus: Bolus?
    var dateTime: String?

    enum CodingKeys: String, CodingKey {
        case userName
        case foodResponseList
        case bolus
        case dateTime
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userName = try container.decode(String.self, forKey: .userName)
        foodResponseList = try container.decode([FoodResponse].self, forKey: .foodResponseList)
        bolus = try container.decode(Bolus.self, forKey: .bolus)
        dateTime = try container.decode(String.self, forKey: .dateTime)
    }
}

struct FoodResponse: Codable, Identifiable {
    var id = UUID()
    var foodType: String?
    var carbonhydrate: Int?
    var foodName: String?

    enum CodingKeys: String, CodingKey {
        case foodType
        case carbonhydrate
        case foodName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        foodType = try container.decode(String.self, forKey: .foodType)
        carbonhydrate = try container.decode(Int.self, forKey: .carbonhydrate)
        foodName = try container.decode(String.self, forKey: .foodName)
    }
}
