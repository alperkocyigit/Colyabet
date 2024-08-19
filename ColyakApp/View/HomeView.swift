//
//  HomeView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import CarBode
import AVFoundation

struct HomeView: View {
    @StateObject var foodList = MealViewModel()
    @StateObject var popularFoodViewModel = PopularReceiptViewModel()
    @StateObject var favoriteViewModel = FavoriteViewModel()
    @State var showingScanner = false
    @State var showingGenerator = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack{
                    NavigationLink{
                        ModalScannerView()
                    }label:{
                        HStack {
                            Image(systemName: "barcode.viewfinder")
                                .font(.system(size: 50))
                                .foregroundColor(.orange)
                                .fontWeight(.bold)
                            VStack {
                                Text("Barkod Okuyucu")
                                    .fontWeight(.heavy)
                                    .foregroundColor(.orange)
                                    .font(.system(size: 22))
                                    
                                Text("Tükettiğiniz ürün uygulamamızda mevcutsa kodu okutarak besin değerlerine ulaşabilirsiniz.")
                                    .font(.system(size: 11).weight(.semibold))
                                    .padding(.top,1)
                                    .padding(.leading,4)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.primary)
                            
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.orange.opacity(0.9), radius: 10, x: 0, y: 5)
                        
                       
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.80)
                    .padding(.top)
                }
                .padding(.bottom,30)
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "flame.fill")
                            .resizable()
                            .frame(width: 20, height: 25)
                            .foregroundColor(.orange)
                            .padding(.trailing, 5)
                        
                        Text("En Popüler Tarifler")
                            .font(.system(size: 24))
                            .fontWeight(.heavy)
                        Spacer()
                    }
                    .padding(.leading, 25)
                    
                    VStack{
                        TopFoodView(receipts: popularFoodViewModel.allpopularReceipts, favoriteReceipts: favoriteViewModel.favoriteReceiptAll)
                    }
                    .padding(.top)
                    .padding(.bottom)
                    // Diğer yemekler listesi
                    VStack {
                        MealView(foodList: foodList)
                    }
                }
            }
            .onAppear(perform: {
                popularFoodViewModel.fetchAllPopularReceipts()
                favoriteViewModel.fetchAllFavoriteReceipts()
            })
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .padding(.top)
            .refreshable(action: {
                favoriteViewModel.fetchAllFavoriteReceipts()
            })
        }
    }
}

#Preview {
    HomeView()
}

struct TopFoodView : View {
    @StateObject var viewModel = ReceiptDetailViewModel()
    let receipts: [Receipt]
    let favoriteReceipts: [Receipt]
    
    var body: some View{
        ForEach(receipts, id: \.id) { receipt in
            NavigationLink(destination: ReceiptDetail(viewModel:viewModel, receipt: receipt, isFavorite: favoriteReceipts.contains { $0.id == receipt.id })){
                TopReceiptDetailView(receipt: receipt)
            }
        }
    }
}



