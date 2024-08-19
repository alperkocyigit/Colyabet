//
//  ReceiptsDetailView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 13.07.2024.
//

import SwiftUI
import SegmentedPicker
import SDWebImageSwiftUI

struct ReceiptDetail: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var likeViewModel = FavoriteViewModel()
    @ObservedObject var viewModel = ReceiptDetailViewModel()
    @State private var selectedSegment : Int?
    @State var selectedLike:Bool
    let receipt: Receipt
    private let pickerElements = ["Malzeme Listesi","Tarif","Besin Değerleri","Yorumlar"]
    
    init(viewModel: ReceiptDetailViewModel, receipt: Receipt, isFavorite: Bool) {
        self.viewModel = viewModel
        self.receipt = receipt
        self._selectedLike = State(initialValue: isFavorite)
    }
    
    var body: some View {
        VStack(alignment:.center){
            VStack {
                ZStack {
                    
                    Text("\(receipt.receiptName ?? "")")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(Color(red: 0.20, green: 0.20, blue: 0.20))
                        .lineLimit(1)
                        .frame(width: UIScreen.main.bounds.width * 0.7)
                    
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 10, height: 20)
                                .foregroundColor(.black)
                                .padding(.horizontal)
                        })
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            if selectedLike {
                                likeViewModel.receiptUnlike(byId: receipt.id)
                                selectedLike.toggle()
                            } else {
                                likeViewModel.receiptLike(byId: receipt.id)
                                selectedLike.toggle()
                            }
                           
                        }) {
                            VStack {
                                Image(systemName: selectedLike ? "heart.fill" : "heart")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(.red)
                                    .scaleEffect(selectedLike ? 1.2 : 1.0)
                                    .animation(.bouncy)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                }
                
            } //NavigationTitle and Back Button
            .padding(.top)
            .frame(width: UIScreen.main.bounds.width)
        
            ZStack {
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
                                .frame(width:UIScreen.main.bounds.width,height: 200)
                           
                               
                        }
                        .frame(width:UIScreen.main.bounds.width,height: 250)
                    }
                    .indicator(.activity)
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width:UIScreen.main.bounds.width,height: 250)
            }
            
            VStack{
                SegmentedPicker(
                    pickerElements,
                    selectedIndex: $selectedSegment,
                    selectionAlignment: .bottom,
                    content: { item, isSelected in
                        VStack{
                            VStack{
                                Text(item)
                                    .font(.system(size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(isSelected ? Color.black : Color.gray )
                                    .multilineTextAlignment(.center)
                                    .padding(.vertical, 8)
                                    .frame(height: 60)
                            }
                            VStack{
                                Color(red: 0.85, green: 0.85, blue: 0.85).frame(height: 2)
                            }
                        }
                        .frame(width:UIScreen.main.bounds.width/4,height: 70)
                    },
                    selection: {
                        HStack {
                            VStack(spacing: 0) {
                                Spacer()
                                Color(red: 1, green: 0.48, blue: 0.22).frame(height: 5)
                            }
                        }
                    }
                )
                .onAppear {
                    selectedSegment = 0
                }
                .frame(width: UIScreen.main.bounds.width)
                .background( LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                
                // Switch yapısına göre içeriği değiştirme
                switch selectedSegment {
                case 0:
                    IngredientsView(receiptDetail: viewModel.selectedReceipt?.receiptItems ?? [])
                        .padding(.top,4)
                case 1:
                    RecipeView(receiptDetails: viewModel.selectedReceipt?.receiptDetails ?? [String]())
                        .padding(.top,4)
                case 2:
                    NutritionView(nutritionalValues: viewModel.selectedReceipt?.nutritionalValuesList ?? [])
                        .padding(.top,4)
                case 3:
                    CommentView(receipt: receipt)
                        .padding(.top,4)
                default:
                    Text("Geçersiz segment")
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchReceiptDetail(byId: receipt.id)
            
        }
        .padding(.top, 15)
        //Spacer()

    }
}
#Preview {
    ReceiptDetail(viewModel: ReceiptDetailViewModel(), receipt: Receipt.init(id: 1, receiptDetails: ["elma","armut"], receiptItems: [ReceiptItem.init(id: 1, productName: "elma", unit: 2.0, type: "")], receiptName: "elma", nutritionalValuesList: [NutritionalValuesList.init(id: 1, unit: 2, type: "", carbohydrateAmount: 2.0, proteinAmount: 5.0, fatAmount: 6.0, calorieAmount: 100.0)], imageId: 0),isFavorite: false)
}
