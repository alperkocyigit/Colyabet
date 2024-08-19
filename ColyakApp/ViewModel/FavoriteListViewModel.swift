//
//  FavoriteListViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation


class FavoriteViewModel: ObservableObject {
    @Published var favoriteReceiptAll: [Receipt] = []
    @Published var vm = LoginViewModel()
    
    func fetchAllFavoriteReceipts() {
        guard let authToken = vm.getTokenFromUserDefaults() else {
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/likes/favoriteList") else {
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
                    self.favoriteReceiptAll = decodedData
                }
            } catch {
                print("Error decoding favoriteList JSON: \(error)")
            }
        }.resume()
    }
    
    func receiptLike(byId id : Int){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/likes/like") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "receiptId": id
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
                let decodedData = try JSONDecoder().decode(LikeResponse.self, from: data)
                DispatchQueue.main.async {
                    print(decodedData)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func receiptUnlike(byId id : Int){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/likes/unlike") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String : Any] = [
            "receiptId": id
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
            if let decodedData = String(data:data,encoding: .utf8){
                DispatchQueue.main.async {
                    print(decodedData)
                }
            }else {
                print("Cannot decode data into string.")
            }
        }.resume()
    }
}

