//
//  CommentViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

class CommentViewModel:ObservableObject {
    @Published var commentt: String = "Yorum ekle"
    @Published var allComment:[Commentt] = []
    @Published var comment : Commentt?
    @Published var vm = LoginViewModel()
    @Published var allCommentAndReplly:[CommentAndReplly] = []
    var receiptId: Int?
    
    
    func fetchAllComment(byId id: Int){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/comments/receipt/\(id)") else {
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
                let decodedData = try JSONDecoder().decode([Commentt].self, from: data)
                DispatchQueue.main.async {
                    self.allComment = decodedData.reversed()
                }
            } catch {
                print("Error decoding allComment JSON: \(error)")
            }
        }.resume()
    }
    
    func addComment(byId id: Int){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/comments/add") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let requestBody: [String: Any] = [
            "receiptId": id,
            "comment": commentt
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
                let decodedData = try JSONDecoder().decode(Commentt.self, from: data)
                DispatchQueue.main.async {
                    self.comment = decodedData
                }
            } catch {
                print("Error decoding comment JSON: \(error)")
            }
        }.resume()
    }
    
    func fetchAllCommentAndReply(receiptId id: Int){
        guard let authToken = vm.getTokenFromUserDefaults() else{
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/replies/receipt/commentsWithReplyByReceiptId/\(id)") else {
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
                let decodedData = try JSONDecoder().decode([CommentAndReplly].self, from: data)
                DispatchQueue.main.async {
                    self.allCommentAndReplly = decodedData.reversed()
                }
            } catch {
                print("Error decoding allComment JSON: \(error)")
            }
        }.resume()
    }
    
    func deleteComment(byId id: Int) {
        guard let authToken = vm.getTokenFromUserDefaults() else {
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/comments/\(id)") else {
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
                    if let receiptId = self.receiptId {
                        DispatchQueue.main.async {
                            self.fetchAllCommentAndReply(receiptId: receiptId)
                        }
                    }
                } else {
                    print("Failed to delete comment, status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
    
    func changeComment(byId id: Int){
        
        guard let authToken = vm.getTokenFromUserDefaults() else {
            print("No auth token available.")
            return
        }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/comments/\(id)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let requestBody = commentt

        do {
            request.httpBody = requestBody.data(using: .utf8)
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error making DELETE request: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 204 {
                    print("Comment changed successfully.")
                } else {
                    print("Failed to changed comment, status code: \(httpResponse.statusCode)")
                }
            }
        }.resume()
    }
}

struct CommentAndReplly:Codable {
    let commentResponse: Commentt?
    let replyResponses: [Replly]?
}
