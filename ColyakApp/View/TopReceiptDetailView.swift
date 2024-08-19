//
//  TopReceiptDetailView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct TopReceiptDetailView: View {
    let receipt:Receipt
    
    var body: some View {
        VStack {
            HStack{
                WebImage(url: URL(string: "https://api.colyakdiyabet.com.tr/api/image/get/\(receipt.imageId ?? 1)")) { image in
                        image.resizable()
                    } placeholder: {
                        ZStack{
                            Circle()
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                            Image(systemName: "fork.knife")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 30)
                        }
                    }
                    .indicator(.activity)
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(height: 80)
                
                VStack(alignment: .leading) {
                    Text(receipt.receiptName ?? "Ekmek")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    Text("Karb: \(String(format: "%.2f", receipt.nutritionalValuesList?.first?.carbohydrateAmount ?? 0.0))")
                        .foregroundColor(Color(red: 0.61, green: 0.61, blue: 0.61))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundColor(.orange)
            }
            .padding(.horizontal,10)
            .frame(width: UIScreen.main.bounds.width * 0.9,height: 55)
            .background(.white)
            .cornerRadius(12)
            .shadow(
                color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.05), radius: 52.74, y: 3.52
            )
        }
    }
}

#Preview {
    TopReceiptDetailView(receipt:Receipt.init(id: 1, receiptDetails: ["elma","armut"], receiptItems: [ReceiptItem.init(id: 0, productName: "elma", unit: 2.0, type: "")], receiptName: "elma", nutritionalValuesList: [NutritionalValuesList.init(id: 1, unit: 2, type: "", carbohydrateAmount: 2.0, proteinAmount: 5.0, fatAmount: 6.0, calorieAmount: 100.0)], imageId: 0))
}
