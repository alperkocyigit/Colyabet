//
//  ChangePasswordViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation


class ChangePasswordViewModel:ObservableObject{
    @Published var emailVerificationCode : String = ""
    @Published var emaill:String = ""
    @Published var isPasswordChanged: Bool = false
    @Published var newPassword : String = ""
    @Published var passwordChangeTrue: Bool = false
    @Published var wrongEmail:Bool = false
    @Published var custom: Bool = false
    @Published var showingPopup :Bool = false
    
    func changePassword(byEmail email: String) {
        
            guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/users/verify/x0/\(email)") else {
                print("Invalid URL")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            let requestBody = emailVerificationCode

            do {
                request.httpBody = requestBody.data(using: .utf8)
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data else {
                    print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                if let decodedData = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        if let range = decodedData.range(of:"ID: "){
                            let changePassId = String(decodedData[range.upperBound...]).trimmingCharacters(in: .whitespacesAndNewlines)
                            self.emailVerificationCode = changePassId
                            self.isPasswordChanged = true
                            print(self.emailVerificationCode)
                            print(self.isPasswordChanged)
                        }else{
                            self.wrongEmail = true
                            print(decodedData)
                        }
                    }
                } else {
                    print("Cannot decode data into string.")
                }
            }.resume()
        }

    func changePasswordId(changepassId : String){
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/users/verify/x1") else {
            print("Invalid URL")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String : String] = [
              "changepassId": changepassId,
              "newPassword": newPassword
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
                    if decodedData == "Failed to change password."{
                        self.passwordChangeTrue = false
                        self.custom = false
                        self.showingPopup = true
                    }else{
                        self.passwordChangeTrue = true
                        self.custom = true
                        self.showingPopup = true
                    }
                    print(decodedData)
                }
            }else {
                print("Cannot decode data into string.")
            }
        }.resume()
    }
}

