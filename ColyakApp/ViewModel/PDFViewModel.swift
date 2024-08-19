//
//  PDFViewModel.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import Foundation

class PDFViewModel : ObservableObject {
    @Published var allPdf : [PDF] = []
    @Published var pdf : PDF?
    @Published var vm = LoginViewModel()
    @Published var loading = true
    
    func pdfListData() {
   
        guard let url = URL(string: "https://api.colyakdiyabet.com.tr/api/image/get/pdfListData2") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode([PDF].self, from: data)
                DispatchQueue.main.async {
                    self.allPdf = decodedData
                    self.loading = false
                }
            } catch {
                print("Error decoding JSON: \(error)")
            }
        }.resume()
    }
}

