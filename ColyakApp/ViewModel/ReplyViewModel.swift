//
//  ReplyViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

class ReplyViewModel:ObservableObject {
    @Published var replly = "Cevapla"
    @Published var allReply:[Replly] = []
    @Published var reply : Replly?
    @Published var vm = LoginViewModel()
    var commentId:Int?
    
    
    func fetchAllReply(byId id: Int){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/replies/comments/\(id)") else {
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
            do{
                let decodedData = try JSONDecoder().decode([Replly].self, from: data)
                DispatchQueue.main.async {
                    self.allReply = decodedData.reversed()
                }
            } catch {
                print("Error decoding allReply JSON: \(error)")
            }
        }.resume()
    }
    
    func addReply(byId id: Int){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/replies/add") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "commentId": id,
            "reply": replly
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
                let decodedData = try JSONDecoder().decode(Replly.self, from: data)
                DispatchQueue.main.async {
                    self.reply = decodedData
                  
                }
            } catch {
                print("Error decoding addReply JSON: \(error)")
            }
        }.resume()
    }
    
    func deleteReply(byId id: Int) {
        guard let authToken = vm.getTokenFromUserDefaults() else {
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/replies/\(id)") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making DELETE request: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                    print("Comment deleted successfully.")
                    DispatchQueue.main.async {
                        if let commentId = self.commentId{
                            self.fetchAllReply(byId: commentId)
                        }
                    }
                } else {
                    print("Failed to delete comment, status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func changeReply(byId id: Int, newReply:String) {
        guard let authToken = vm.getTokenFromUserDefaults() else {
            print("No auth token available.")
            return
        }
        
        var urlComponents = URLComponents(string: "https://api.colyakdiyabet.com.tr/api/replies/\(id)")
        urlComponents?.queryItems = [URLQueryItem(name: "newReply", value: newReply)]
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
       
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making PUT request: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                    print("Reply restored successfully.")
                    if let commentId = self.commentId{
                        self.fetchAllReply(byId: commentId)
                    }
                } else {
                    print("Failed to put reply, status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    
}

