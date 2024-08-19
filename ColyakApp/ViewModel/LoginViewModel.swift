//
//  LoginViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation
import Alamofire
import Combine

class LoginViewModel: ObservableObject {
    @Published var accessToken: String = ""
    @Published var refreshToken: String = ""
    @Published var email = ""
    @Published var passwordd = ""
    @Published var isLoggedIn = false
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    
    private var accessTokenExpirationDate: Date?
    private var refreshTokenExpirationDate: Date?
    
    init() {
        self.checkLoginStatus()
    }
    
    func saveUsernameToUserDefaults(userName:String){
        UserDefaults.standard.set(userName, forKey: "userName")
    }
    
    func getUsernameUserDefaults() -> String?{
        UserDefaults.standard.string(forKey: "userName")
    }
    
    func saveEmailToUserDefaults(email: String) {
        UserDefaults.standard.set(email, forKey: "userEmail")
    }
    
    func getEmailFromUserDefaults() -> String? {
        return UserDefaults.standard.string(forKey: "userEmail")
    }
    
    func saveTokenToUserDefaults(token: String, refreshToken: String, tokenExpiry: Date, refreshTokenExpiry: Date) {
        UserDefaults.standard.set(token, forKey: "accessToken")
        UserDefaults.standard.set(refreshToken, forKey: "refreshToken")
        UserDefaults.standard.set(tokenExpiry, forKey: "tokenExpiry")
        UserDefaults.standard.set(refreshTokenExpiry, forKey: "refreshTokenExpiry")
    }
    
    func getTokenFromUserDefaults() -> String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    func getRefreshTokenFromUserDefaults() -> String? {
           return UserDefaults.standard.string(forKey: "refreshToken")
       }
    
    func getTokenExpiryFromUserDefaults() -> Date? {
        return UserDefaults.standard.object(forKey: "tokenExpiry") as? Date
    }

    func getRefreshTokenExpiryFromUserDefaults() -> Date? {
        return UserDefaults.standard.object(forKey: "refreshTokenExpiry") as? Date
    }
    
    func checkLoginStatus() {
            if let token = getTokenFromUserDefaults(),
               let tokenExpiry = getTokenExpiryFromUserDefaults(),
               let refreshToken = getRefreshTokenFromUserDefaults(),
               let refreshTokenExpiry = getRefreshTokenExpiryFromUserDefaults(){
                
                self.accessToken = token
                self.refreshToken = refreshToken
                self.isLoggedIn = true

                if Date() >= refreshTokenExpiry {
                    logOutUser()
                   
                } else {
                    let timeIntervalToRefreshTokenExpire = refreshTokenExpiry.timeIntervalSince(Date())
                    DispatchQueue.main.asyncAfter(deadline: .now() + timeIntervalToRefreshTokenExpire) {
                        self.logOutUser()
                      
                    }
                    
                    if Date() >= tokenExpiry {
                        refreshAccessToken()
                        
                    } else {
                        let timeIntervalToExpire = tokenExpiry.timeIntervalSince(Date())
                        DispatchQueue.main.asyncAfter(deadline: .now() + timeIntervalToExpire) {
                            self.refreshAccessToken()
                            
                        }
                    }
                }
            } else {
                self.isLoggedIn = false
                clearToken()
            }
        }

        
    func loginUser() {
        let url = "https://api.colyakdiyabet.com.tr/api/users/verify/login"
        
        let parameters: [String: String] = [
            "email": email.trimmingCharacters(in: .whitespaces),
            "password": passwordd.trimmingCharacters(in: .whitespaces)
        ]
        self.isLoading = true
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: LoginResponse.self) { response in
                switch response.result {
                case .success(let decodedResponse):
                    DispatchQueue.main.async {
                        print("\(decodedResponse)")
                        self.isLoggedIn = true
                        
                        self.saveEmailToUserDefaults(email: self.email)
                        
                        if let userName = decodedResponse.userName {
                            self.saveUsernameToUserDefaults(userName: userName)
                        }
                        if let token = decodedResponse.token, let refreshToken = decodedResponse.refreshToken {
                            self.accessToken = token
                            self.refreshToken = refreshToken
                            self.saveTokenToUserDefaults(
                                token: token,
                                refreshToken: refreshToken,
                                tokenExpiry: Date().addingTimeInterval(3540),
                                refreshTokenExpiry: Date().addingTimeInterval(29 * 24 * 60 * 60)
                            )
                            self.checkLoginStatus()
                        }
                        self.isLoading = false
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.isLoading = false
                    }
                }
            }
    }
    
    func clearToken() {
        self.accessToken = ""
        self.refreshToken = ""
        self.email = ""
        self.passwordd = ""
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "refreshToken")
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "tokenExpiry")
        UserDefaults.standard.removeObject(forKey: "refreshTokenExpiry")
    }
    
    private func refreshAccessToken() {
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/users/verify/refresh-token") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let requestBody: [String: Any] = [
            "refreshToken": self.refreshToken
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            do {
                let jsonResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                if let newAccessToken = jsonResponse.token {
                    DispatchQueue.main.async {
                        self.accessToken = newAccessToken
                        UserDefaults.standard.set(newAccessToken, forKey: "accessToken")
                        let tokenExpiry = Date().addingTimeInterval(3540)
                        UserDefaults.standard.set(tokenExpiry, forKey: "tokenExpiry")
                        print(self.accessToken)
                    }
                }
            }catch {
                print("Failed to decode access token: \(error)")
            }
        }.resume()
    }
    func logOutUser() {
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/users/verify/logout") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let logoutString = self.getTokenFromUserDefaults() {
            print("Token found: \(logoutString)")
            request.httpBody = logoutString.data(using: .utf8)
        } else {
            print("Token not found")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Network error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // Response işleme
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                do {
                    let jsonResponse = try JSONDecoder().decode(Bool.self, from: data)
                    if jsonResponse {
                        DispatchQueue.main.async {
                            print("Logout succesfully")
                            self.clearToken()
                            self.isLoggedIn = false
                        }
                    } else {
                        print("Logout failed: \(jsonResponse)")
                    }
                } catch {
                    print("Failed to decode logout response: \(error)")
                }
            } else {
                print("Logout failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? -1)")
            }
        }.resume()
    }
}




