//
//  PopularReceiptViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

class PopularReceiptViewModel: ObservableObject {
    @Published var allpopularReceipts: [Receipt] = []
    @Published var vm = LoginViewModel()
    
    func fetchAllPopularReceipts() {
        guard let authToken = vm.getTokenFromUserDefaults() else {
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/meals/report/top5receipts") else {
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
                let decodedData = try JSONDecoder().decode([Receipt].self, from: data)
                DispatchQueue.main.async {
                    self.allpopularReceipts = decodedData
                }
            } catch {
                print("Error decoding Popular Receipt JSON: \(error)")
            }
        }.resume()
    }
}

