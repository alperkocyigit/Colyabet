//
//  LoginModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
struct LoginResponse: Codable {
    let token, refreshToken: String?
    let role: [String?]?
    let userName: String?
}
