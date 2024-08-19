//
//  ReceiptsView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//
import SwiftUI
import SegmentedPicker
import CustomizableSegmentedControl
import SDWebImageSwiftUI

struct ReceiptsView: View {
    @Binding var showCancel :Bool
    @ObservedObject var viewModel = ReceiptsViewModel()
    @StateObject var favoriteViewModel = FavoriteViewModel()
    @State private var selection: Option = .first
    @State private var searchText = ""
    private let options: [Option] = [.first, .second]
    var body: some View {
        NavigationView {
            VStack {
                SearchBarCustomView(searchText: $searchText)
                    .padding(.horizontal, 18)
                CustomizableSegmentedControl(
                    selection: $selection,
                    options: options,
                    selectionView: selectionView(),
                    segmentContent: { option, isPressed in
                        segmentView(title: option.title, isPressed: isPressed)
                            .colorMultiply(selection == option ? Color.white : .black)
                            .animation(.default, value: selection)
                    }
                )
                .segmentedControlSlidingAnimation(.default)
                .frame(height: 70)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(14)
                .padding()

                switch selection {
                case .first:
                    FoodView(searchText: $searchText, receipts: viewModel.allReceipts, favoriteReceipts: favoriteViewModel.favoriteReceiptAll)
                        .onAppear {
                            viewModel.fetchAllReceipts()
                        }
                case .second:
                    FoodView(searchText: $searchText, receipts: favoriteViewModel.favoriteReceiptAll, favoriteReceipts: favoriteViewModel.favoriteReceiptAll)
                        .onAppear {
                            favoriteViewModel.fetchAllFavoriteReceipts()
                        }
                default:
                    Text("Geçersiz segment")
                }
            }
        }
    }

    private func selectionView(color: Color = Color(red: 1, green: 0.48, blue: 0.22)) -> some View {
        color
            .frame(height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 14))
    }

    private func segmentView(title: String, isPressed: Bool) -> some View {
        HStack(spacing: 4) {
            Text(title)
                .font(.system(size: 16, weight: .semibold, design: .rounded))
        }
        .foregroundColor(.white.opacity(isPressed ? 0.7 : 1))
        .lineLimit(1)
        .padding(.vertical, 10)
        .padding(.horizontal, 12)
        .frame(maxWidth: .infinity)
    }
}
private enum Option: String, CaseIterable, Identifiable, Hashable {
    case first
    case second

    var id: String { rawValue }
    var title: String {
        switch self {
        case .first:
            return "Tarifler"
        case .second:
            return "Favori Tarifler"
        }
    }
}

/*#Preview {
    ReceiptsView(showCancel: .constant(false))
}*/


struct FoodView: View {
    @StateObject var viewModel = ReceiptDetailViewModel()
    @Binding var searchText: String
    let receipts: [Receipt]
    let favoriteReceipts: [Receipt]
    
    
    var filteredReceipts: [Receipt] {
        if searchText.isEmpty {
            return receipts
        } else {
            return receipts.filter {
                $0.receiptName!.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: (UIScreen.main.bounds.width - 60) / 2, maximum: .infinity)),GridItem(.adaptive(minimum: (UIScreen.main.bounds.width - 60) / 2, maximum: .infinity))]) {
                ForEach(filteredReceipts, id: \.id) { receipt in
                    NavigationLink(destination: ReceiptDetail(viewModel:viewModel, receipt: receipt, isFavorite: favoriteReceipts.contains { $0.id == receipt.id })){
                        ReceiptCard(receipt: receipt)
                            .frame(height: 250)
                    }
                }
            }
            .padding(.horizontal, 10)
            .padding(.top,5)
            .padding(.bottom,5)
        }
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
    }
}

struct ReceiptCard: View {
    let receipt:Receipt
    var body: some View {
        VStack {
            WebImage(url: URL(string: "https://api.colyakdiyabet.com.tr/api/image/get/\(receipt.imageId ?? 1)")){ image in
                    image.resizable()
                } placeholder: {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                        Image(systemName: "fork.knife")
                            .resizable()
                            .foregroundColor(.black)
                            .scaledToFit()
                            .cornerRadius(10)
                            .frame(width:UIScreen.main.bounds.width,height: 100)
                       
                           
                    }
                    .frame(width:UIScreen.main.bounds.width,height: 150)
                    .cornerRadius(10)
                }
                .indicator(.activity)
                .scaledToFit()
                .cornerRadius(10)
                .frame(width:UIScreen.main.bounds.width,height: 150)
                .padding(.top)
            
            HStack {
                Text(receipt.receiptName?.uppercased() ?? "")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                Spacer()
            }
            .padding(.top)
            .padding(.horizontal)
        
            HStack{
                Text("Karb: \(String(format: "%.2f", receipt.nutritionalValuesList?.first?.carbohydrateAmount ?? 0.0))")
                    .foregroundColor(Color(red: 0.61, green: 0.61, blue: 0.61))
                Spacer()
            }
            .padding(.leading)
            .padding(.top,6)
          
            Spacer()
            
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity) //bulunduğu yere göre şekil alıyor
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct IngredientsView: View {
    let receiptDetail: [ReceiptItem]
    @State private var selectedIngredientIndex = 0
        
    var body: some View {
        ScrollView{
            VStack(spacing:12){
                ForEach(receiptDetail,id: \.id) { item in
                    VStack{
                        HStack(spacing:10) {
                            Text(item.productName ?? "")
                                .font(.system(size: 18))
                                .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                           Spacer()
                            HStack{
                                Text(formatUnit(item.unit))
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                              
                                Text(item.type ?? "")
                                    .font(.system(size: 18))
                                    .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                            }
                           
                        }
                     
                    }
                }
                .padding(.leading)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            .background(.white)
            .cornerRadius(16)
            .shadow(
            color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.05), radius: 60, y: 4)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .shadow(
        color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.05), radius: 60, y: 4)
    }

    private func formatUnit(_ unit: Double?) -> String {
        guard let unitValue = unit else { return "0" }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = unitValue.truncatingRemainder(dividingBy: 1) != 0 ? 1 : 0
        
        return formatter.string(from: NSNumber(value: unitValue)) ?? "0"
    }
}
#Preview {
    IngredientsView(receiptDetail: [ReceiptItem.init(id: 1, productName: "armut", unit: 2.0, type: "elma"),ReceiptItem.init(id: 1, productName: "armut", unit: 2.0, type: "elma"),ReceiptItem.init(id: 1, productName: "armut", unit: 2.0, type: "elma"),ReceiptItem.init(id: 1, productName: "armut", unit: 2.0, type: "elma")])
}

struct RecipeView: View {
    let receiptDetails: [String]
    var body: some View {
        ScrollView{
            HStack {
                VStack(alignment:.leading,spacing: 20) {
                    ForEach(0..<receiptDetails.count, id: \.self) { detail in
                        HStack(spacing:10){
                            HStack{
                                Text("\(detail + 1))")
                            }
                            .frame(width: 25)
                            Text(receiptDetails[detail])
                                .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
                .padding()
                Spacer()
            }
        }
    }
}
struct NutritionView: View {
    let nutritionalValues: [NutritionalValuesList]
    var body: some View {
        ScrollView {
            if !nutritionalValues.isEmpty{
                ForEach(nutritionalValues,id: \.id) { nutrition in
                    VStack {
                        VStack{
                            Spacer()
                            HStack{
                                Rectangle()
                                     .foregroundColor(.clear)
                                     .frame(width: 5, height: 30)
                                     .background(Color(red: 1, green: 0.48, blue: 0.22))
                                     .cornerRadius(8.93)
                                     .rotationEffect(.degrees(180))
                                Spacer()
                                if let unit = nutrition.unit {
                                    Text("\(unit)")
                                        .fontWeight(.semibold)
                                }
                                Text(nutrition.type ?? "")
                                    .fontWeight(.semibold)
                                Spacer()
                                Rectangle()
                                     .foregroundColor(.clear)
                                     .frame(width: 5, height: 30)
                                     .background(Color(red: 1, green: 0.48, blue: 0.22))
                                     .cornerRadius(8.93)
                                     .rotationEffect(.degrees(0))
                            }
                            Spacer()
                        }
                        .background(LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                        .frame(width:UIScreen.main.bounds.width * 0.8, height: 60)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.bottom,15)
                        
                     
                        VStack(spacing:20) {
                            NutritionRow(title: "Kalori", value: nutrition.calorieAmount)
                            NutritionRow(title: "Karbonhidrat (g)", value: nutrition.carbohydrateAmount)
                            NutritionRow(title: "Protein (g)", value: nutrition.proteinAmount)
                            NutritionRow(title: "Yağ(g)", value: nutrition.fatAmount)
                        }
                        .padding()
                        .frame(width:UIScreen.main.bounds.width * 0.8)
                        .background(.white)
                        .cornerRadius(16)
                        .shadow(
                             color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.05), radius: 60, y: 4
                           )
                    }
                    .padding(.vertical)
                }
            } else {
                Text("Besin değerleri bulunamadı.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .scrollIndicators(.hidden)
    }
}
/*struct NutritionView_Previews: PreviewProvider {
    static var previews: some View {
        NutritionView(nutritionalValues: [NutritionalValuesList.init(id: 1, unit: 105, type: "gram", carbohydrateAmount: 2.0, proteinAmount: 5.0, fatAmount: 8.0, calorieAmount: 15.0)])
    }
}*/

struct NutritionRow: View {
    let title: String
    let value: Double?
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
            Spacer()
            if let value = value {
                Text(String(value))
                    .font(.system(size: 15))
            } else {
                Text("Bilgi yok")
                    .font(.system(size: 15))
            }
        }
        .frame(height: 15)
    }
}




