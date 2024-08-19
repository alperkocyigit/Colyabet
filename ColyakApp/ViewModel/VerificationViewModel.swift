//
//  VerificationViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
class VerificationViewModel : ObservableObject {
    @Published var oneTimeCode: String = ""
    @Published var codeResponse : String = ""
    @Published var isCodeChecked: Bool = false
    @Published var isCodeCorrect: Bool = false
   
    
    func VerificationUser(verificationId : String) {
        let url = URL(string: "https://api.colyakdiyabet.com.tr/api/users/verify/verify-email")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: AnyHashable] = [
            "verificationId": verificationId,
            "oneTimeCode": oneTimeCode,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody,options: .fragmentsAllowed)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decodedData = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    self.codeResponse = decodedData
                    self.isCodeChecked = true
                    self.isCodeCorrect = (self.codeResponse == "true")
                }
            } else {
                print("Cannot decode data into string.")
            }
        }.resume()
    }
}

