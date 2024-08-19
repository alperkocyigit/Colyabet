//
//  BarcodeDetailsViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 9.07.2024.
//

import Foundation

class BarcodeDetailsViewModel:ObservableObject{
    @Published var selectedBarcodes: Barcode?
    @Published var vm = LoginViewModel()
    @Published var code = ""
    @Published var isFound : Bool? = nil
    private var session : URLSession
    
    init(session : URLSession = URLSession.shared){
        self.session = session
    }
    
    func fetchDetailBarcode(byId id: Int){
        
        guard let authToken = vm.getTokenFromUserDefaults() else {
                print("No auth token available.")
                return
            }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/barcodes/get/byId/\(id)") else {
            print("invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(Barcode.self, from: data)
                DispatchQueue.main.async{
                    self.selectedBarcodes = decodedData
                }
            }catch{
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
    
    func barcodeCodeSearch(by code:String){
        guard let authToken = vm.getTokenFromUserDefaults() else {
                print("No auth token available.")
                return
            }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/barcodes/code/\(code)") else {
            print("invalid URL ")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do{
                let decodedData = try JSONDecoder().decode(Barcode.self, from: data)
                DispatchQueue.main.async{
                    self.isFound = true
                    self.selectedBarcodes = decodedData
                    
                }
            }catch{
                DispatchQueue.main.async{
                    self.isFound = false
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
    
}
