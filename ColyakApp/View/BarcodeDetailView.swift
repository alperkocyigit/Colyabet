//
//  BarcodeDetailView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct BarcodeDetailView: View {
    @StateObject var selectedBarcodes : BarcodeDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Image Section
                VStack {
                    AsyncImage(url: URL(string: "https://api.colyakdiyabet.com.tr/api/image/get/\(selectedBarcodes.selectedBarcodes?.imageId ?? 1)")) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(10)
                                .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.width * 0.7)
                                
                        } else if phase.error != nil {
                          
                            Image(systemName: "fork.knife")
                                .resizable()
                                .foregroundColor(.black)
                                .scaledToFit()
                                .cornerRadius(10)
                                .frame(width:UIScreen.main.bounds.width,height: UIScreen.main.bounds.width * 0.7)
                        } else {
                            ProgressView()
                        }
                    }
                    
                    Text(selectedBarcodes.selectedBarcodes?.name ?? "")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 10)
                        .padding(.horizontal)
                }
                
                // Details Section
                VStack(spacing: 10) {
                    detailRow(title: "Barkod No:", value: String(selectedBarcodes.selectedBarcodes?.code ?? 0000000000000))
                    detailRow(title: "Glütensiz:", value: selectedBarcodes.selectedBarcodes?.glutenFree ?? false ? "Evet" : "Hayır")
                }
                .padding(.horizontal, 15)
                .multilineTextAlignment(.leading)
                
                Spacer()
                // Nutritional Values Section
                VStack(alignment: .leading) {
                    if let nutritionalValues = selectedBarcodes.selectedBarcodes?.nutritionalValuesList{
                        ForEach(nutritionalValues) { value in
                            nutritionalValueRow(value: value)
                        }
                    }
                }
                .padding(.horizontal)
                
               
            }
            .navigationTitle(selectedBarcodes.selectedBarcodes?.name ?? "Ürün Detayı")
            .padding(.top, 20)
        }
    }
    
    private func detailRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 20))
                .foregroundColor(.orange)
                .bold()
                .multilineTextAlignment(.leading)
            Spacer()
            Text(value)
                .font(.system(size: 20))
                .fontWeight(.medium)
        }
        .padding(.horizontal)
    }
    
    private func nutritionalValueRow(value: NutritionalValuesList) -> some View {
        HStack {
            Spacer()
            VStack(alignment: .leading, spacing: 5) {
                detailSubRow(title: "Ürün Tipi:", value: value.type ?? "")
                detailSubRow(title: "Birimi:", value: "\(value.unit ?? 0)g")
                detailSubRow(title: "Karbonhidrat:", value: "\(value.carbohydrateAmount ?? 0)g")
                detailSubRow(title: "Protein:", value: "\(value.proteinAmount ?? 0)g")
                detailSubRow(title: "Yağ:", value: "\(value.fatAmount ?? 0)g")
                detailSubRow(title: "Kalori:", value: "\(value.calorieAmount ?? 0) kcal")
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            Spacer()
        }
    }
    
    private func detailSubRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.orange)
                .fontWeight(.bold)
            Spacer()
            Text(value)
        }
        .font(.system(size: 20))
    }
}

struct BarcodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeDetailView(selectedBarcodes: BarcodeDetailsViewModel())
    }
}
