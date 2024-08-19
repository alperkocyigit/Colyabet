//
//  MealViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

// Meal model


// Meal view model
class MealViewModel: ObservableObject {
    @Published var vm = LoginViewModel()
    @Published var response: MealResponse?
    @Published var food: [Food] = []
    
    func addMeal(food: [Food], bolus: Bolus) {
        guard let authToken = vm.getTokenFromUserDefaults() else {
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/meals/add") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "foodList": food.map { [
                "foodType": $0.foodType.rawValue,
                "foodId": $0.foodId,
                "carbonhydrate": $0.carbonhydrate ?? 0
            ]},
            "bolus": [
                "bloodSugar": bolus.bloodSugar ?? 0,
                "targetBloodSugar": bolus.targetBloodSugar ?? 0,
                "insulinTolerateFactor": bolus.insulinTolerateFactor ?? 0,
                "totalCarbonhydrate": bolus.totalCarbonhydrate ?? 0,
                "insulinCarbonhydrateRatio": bolus.insulinCarbonhydrateRatio ?? 0,
                "bolusValue": bolus.bolusValue ?? 0,
                "eatingTime": bolus.eatingTime ?? ""
            ]
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(MealResponse.self, from: data)
                DispatchQueue.main.async {
                    self.response = decodedData
                    print(self.response ?? "error")
                }
            } catch {
                print("Error decoding comment JSON: \(error)")
            }
        }.resume()
    }
}

struct MealResponse: Codable {
    let userName: String?
    let foodResponseList: [FoodResponseList]?
    let bolus: Bolus?
    let dateTime:String
}

// MARK: - FoodResponseList
struct FoodResponseList: Codable {
    let foodType: String?
    let carbonhydrate: Int?
    let foodName: String?
}

