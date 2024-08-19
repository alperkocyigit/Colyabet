//
//  SuggestionViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

class SuggestionViewModel:ObservableObject {
    @Published var vm = LoginViewModel()
    @Published var suggestion = "" {
            didSet {
                if !suggestion.isEmpty {
                    suggestionBarcode = ""
                    isBarcodeDisabled = true
                } else {
                    isBarcodeDisabled = false
                }
            }
        }
    @Published var suggestionBarcode = "" {
            didSet {
                if !suggestionBarcode.isEmpty {
                    suggestion = ""
                    isSuggestionDisabled = true
                } else {
                    isSuggestionDisabled = false
                }
            }
        }
    @Published var productName = ""
    @Published var isSuggestionDisabled = false
    @Published var isBarcodeDisabled = false
    @Published var sent: Bool = false
    var combinedText:String{
        return "\(suggestionBarcode) | \(productName)"
    }
    
    func addSuggestion(){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/suggestions/add") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "suggestion": suggestion
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(SuggestionResponse.self, from: data)
                DispatchQueue.main.async {
                    print(decodedData)
                    self.sent = true
                }
            } catch {
                print("Error decoding comment JSON: \(error)")
            }
        }.resume()
    }
    
    func addSuggestionBarcode(){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/suggestions/add") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "suggestion": combinedText
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            print("Error serializing JSON: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(SuggestionResponse.self, from: data)
                DispatchQueue.main.async {
                    self.sent = true
                    print(decodedData)
                }
            } catch {
                print("Error decoding comment JSON: \(error)")
            }
        }.resume()
    }
}


