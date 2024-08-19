//
//  QuizViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation


class QuizViewModel:ObservableObject {
    @Published var score : Int = 0
    @Published var quiz : Quiz?
    @Published var allQuiz : [Quiz] = []
    @Published var vm = LoginViewModel()
    
    func fetchAllQuiz(){
        guard let authToken = vm.getTokenFromUserDefaults() else {
                print("No auth token available.")
                return
            }
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/quiz/all") else {
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
                let decodedData = try JSONDecoder().decode([Quiz].self, from: data)
                DispatchQueue.main.async {
                    self.allQuiz = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func selectedQuiz(byId id: Int){
        guard let authToken = vm.getTokenFromUserDefaults() else {
                print("No auth token available.")
                return
            }
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/quiz/byId/\(id)") else {
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
                let decodedData = try JSONDecoder().decode(Quiz.self, from: data)
                DispatchQueue.main.async {
                    self.quiz = decodedData
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
     func submitAnswer(questionId: Int, chosenAnswer: String) {
            // URL ve body parametreleri ayarlanır
         
         guard let authToken = vm.getTokenFromUserDefaults() else {
             print("No auth token available.")
             return
         }
         guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/user-answer/submit-answer") else{
             print("Invalid URL")
             return
         }
            
            // URLRequest oluşturulur
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            let requestBody: [String: Any] = [
                "questionId": questionId,
                "chosenAnswer": chosenAnswer
            ]
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
            } catch {
                print("Error serializing JSON: \(error)")
                return
            }
            URLSession.shared.dataTask(with: request) { data, response, error in
                // Hata kontrolü yapılır
                if let error = error {
                    print("Error: \(error)")
                    return
                }
                
                // Yanıt kontrolü yapılır
                if let httpResponse = response as? HTTPURLResponse {
                    print("Status Code: \(httpResponse.statusCode)")
                }
                
                // Yanıt verisi kontrolü yapılır
                if let data = data {
                    let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                    print("Response: \(responseJSON ?? "")")
                }
            }.resume()
        }
    
    func fetchQuizScore(byId id:Int)async throws{
        guard let authToken = vm.getTokenFromUserDefaults() else {
                print("No auth token available.")
                return
            }
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/user-answer/user-score/\(id)") else {
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
                let decodedData = try JSONDecoder().decode(Int.self, from: data)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.score = decodedData
                    print(self.score)
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }

}



