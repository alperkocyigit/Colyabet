//
//  BarcodeViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

class BarcodeViewModel:ObservableObject{
    @Published var allBarcodes : [Barcode] = []
    @Published var barcodes: Barcode?
    @Published var vm = LoginViewModel()
    private let session:URLSession
    
    init(session:URLSession = URLSession.shared){
        self.session = session
    }
    
    func fetchAllBarcode(){
        
        guard let authToken = vm.getTokenFromUserDefaults() else {
                print("No auth token available.")
                return
            }
        
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/barcodes/all") else {
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
                let decodedData = try JSONDecoder().decode([Barcode].self, from: data)
                DispatchQueue.main.async{
                    self.allBarcodes = decodedData
                    print(self.allBarcodes)
                }
            }catch{
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}





