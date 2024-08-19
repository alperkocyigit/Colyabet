//
//  ReceiptViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation


class ReceiptsViewModel: ObservableObject {
    @Published var allReceipts: [Receipt] = []
    @Published var selectedReceipt: Receipt?
    @Published var vm = LoginViewModel()
    
    func fetchAllReceipts() {
        guard let authToken = vm.getTokenFromUserDefaults() else {
                print("No auth token available.")
                return
            }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/receipts/getAll/all") else {
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
                    self.allReceipts = decodedData
                }
            } catch {
                print("Error decoding receipts JSON: \(error)")
            }
        }.resume()
    }
}

class ReceiptDetailViewModel: ObservableObject {
    @Published var selectedReceipt: Receipt?
    @Published var vm = LoginViewModel()
    
    func fetchReceiptDetail(byId id: Int) {
        
        guard let authToken = vm.getTokenFromUserDefaults() else {
                print("No auth token available.")
                return
            }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/receipts/getbyId/\(id)") else {
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
                let decodedData = try JSONDecoder().decode(Receipt.self, from: data)
                DispatchQueue.main.async {
                    self.selectedReceipt = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

//https://colyak-4639d4538c5d.herokuapp.com/api/receipt/1/image

