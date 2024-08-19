//
//  UserReportViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

class UserReportsViewModel: ObservableObject {
    @Published var selectionStartDate = Date()
    @Published var selectionEndDate = Date()
    @Published var reports: [UserReport] = []
    @Published var vm = LoginViewModel()
    @Published var response: MealResponse?
    @Published var food: [Food] = []
    init() {
        let currentDate = Date()
        let calendar = Calendar.current
        let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: currentDate)!
        self.selectionStartDate = oneWeekAgo
      
        self.selectionEndDate = selectionEndDate
        self.reports = reports
        self.vm = vm
        self.response = response
        self.food = food
    }
    func fetchReports() {
        guard let authToken = vm.getTokenFromUserDefaults() else {
            print("No auth token available.")
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let startDateStr = formatter.string(from: selectionStartDate)
        let endDateStr = formatter.string(from: selectionEndDate)

        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/meals/report/\(vm.getEmailFromUserDefaults() ?? "")/\(startDateStr)/\(endDateStr)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let decodedData = try JSONDecoder().decode([UserReport].self, from: data)
                DispatchQueue.main.async {
                    self.reports = decodedData.reversed()
                }
            } catch {
                print("Error decoding reports JSON: \(error)")
            }
        }.resume()
    }
}

