//
//  CreateUserViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
class RegisterViewModel : ObservableObject {
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var password: String = ""
    @Published var verificationId : String = ""
    @Published var wrongSignAccount : String = ""
    @Published var wrongBoolean : Bool = false
    @Published var wrongCurrentAccount : Bool = false
    @Published var emailVerifacitonView : Bool = false
    @Published var alertType: AlertType? = nil
    
    func registerUser() {
        let url = URL(string: "https://api.colyakdiyabet.com.tr/api/users/verify/create")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: AnyHashable] = [
            "email": email,
            "name": name,
            "password": password,
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody,options: .fragmentsAllowed)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let decodedData = String(data: data, encoding: .utf8) {
                DispatchQueue.main.async {
                    if decodedData == "The [user.password] property is shorter than the minimum of [8] characters., A user with email [\(self.email)] already exists." {
                        self.wrongBoolean = true
                        self.alertType = .validationPasswordAndCurrentAccount
                     
                        
                    }else if decodedData == "A user with email [\(self.email)] already exists."{
                        self.wrongCurrentAccount = true
                        self.alertType = .currentAccount
                        
                        
                    }else if decodedData == "The [user.password] property is shorter than the minimum of [8] characters."{
                        print(decodedData)
                        
                    }else{
                        self.verificationId = decodedData
                        print(decodedData)
                        self.emailVerifacitonView = true
                    }
                }
            } else {
                print("Cannot decode data into string.")
            }
        }.resume()
    }
}

enum AlertType :Identifiable {
    var id: AlertType { self }
    case passwordMismatch
    case incompleteFields
    case validationEmail
    case validationPassword
    case currentAccount
    case validationPasswordAndCurrentAccount
}
