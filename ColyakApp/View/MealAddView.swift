//
//  MealAddView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct MealAddView: View {
    @StateObject var viewModel = ReceiptsViewModel()
    @StateObject var barcodeViewModel = BarcodeViewModel()
    @StateObject var mealViewModel : MealViewModel
    @State private var selectedIndex = 0
    @State private var searchText = ""
    @State private var searchBarcodeText = ""
    @State private var isSheetPresented = false
    @State private var selectedReceipt: Receipt?
    @State private var selectedBarcode: Barcode?
    
    
    var filteredReceipts: [Receipt] {
        if searchText.isEmpty {
            return viewModel.allReceipts
        } else {
            return viewModel.allReceipts.filter {
                $0.receiptName!.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    var filteredBarcode: [Barcode] {
        if searchBarcodeText.isEmpty {
            return barcodeViewModel.allBarcodes
        } else {
            return barcodeViewModel.allBarcodes.filter {
                $0.name!.localizedCaseInsensitiveContains(searchBarcodeText)
            }
        }
    }
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    selectedIndex = 0
                }, label: {
                    Text("Tarif")
                        .fontWeight(.semibold)
                        .foregroundColor(selectedIndex == 0 ? .white : .black)
                        .frame(width: UIScreen.main.bounds.width * 0.4,height: 70)
                        .background(selectedIndex == 0 ? LinearGradient(gradient:Gradient(colors: [Color(red: 1, green: 0.48, blue: 0.22)]),startPoint: .leading,endPoint: .trailing) :  LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                       
                })
                Button(action: {
                    selectedIndex = 1
                }, label: {
                    Text("Hazır Yemek")
                        .fontWeight(.semibold)
                        .foregroundColor(selectedIndex == 1 ? .white : .black)
                        .frame(width: UIScreen.main.bounds.width * 0.4,height: 70)
                        .background(selectedIndex == 1 ? LinearGradient(gradient:Gradient(colors: [Color(red: 1, green: 0.48, blue: 0.22)]),startPoint: .leading,endPoint: .trailing) :  LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(12)
                })
                
            }
            .frame(width: UIScreen.main.bounds.width * 0.8,height: 70)
            .background(
                    LinearGradient(gradient: Gradient(colors: [Color(red: 1, green: 0.98, blue: 0.95), Color(red: 1, green: 0.94, blue: 0.93)]), startPoint: .leading, endPoint: .trailing)
                  )
            .cornerRadius(12)
            
            if selectedIndex == 0 {
                
                SearchBarCustomView(searchText: $searchText)
                    .padding(.horizontal, 38)
                    .padding(.top,10)
                    .padding(.bottom,10)
                
                NavigationView{
                    ScrollView {
                        LazyVStack(spacing:20) {
                          ForEach(filteredReceipts, id: \.id) { item in
                                VStack {
                                    Button(action: {
                                        isSheetPresented.toggle()
                                        selectedReceipt = item
                                    
                                    }) {
                                        HStack{
                                            Text("\(item.receiptName ?? "Not Found")")
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.black)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 20))
                                                .foregroundColor(.orange)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .frame(width: UIScreen.main.bounds.width * 0.9,height: 60)
                                .background(.white)
                                .cornerRadius(12)
                                .shadow(
                                    color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.05), radius: 52.74, y: 3.52
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .padding(.top)
                    .background(.white)
                    .scrollIndicators(.hidden)
                    .frame(width: UIScreen.main.bounds.width)
                }
            }
            if selectedIndex == 1 {
                
                SearchBarCustomView(searchText: $searchBarcodeText)
                    .padding(.horizontal, 38)
                    .padding(.top,10)
                    .padding(.bottom,10)
                
                NavigationView{
                    ScrollView {
                        LazyVStack(spacing:20) {
                            ForEach(filteredBarcode, id: \.id) { item in
                                VStack {
                                    Button(action: {
                                        selectedBarcode = item
                                        isSheetPresented.toggle()
                                    }) {
                                        HStack{
                                            Text("\(item.name ?? "Not Found")")
                                                .multilineTextAlignment(.leading)
                                                .foregroundColor(.black)
                                                .lineLimit(2)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.system(size: 20))
                                                .foregroundColor(.orange)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                .frame(width: UIScreen.main.bounds.width * 0.9,height: 60)
                                .background(.white)
                                .cornerRadius(12)
                                .shadow(
                                    color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.05), radius: 52.74, y: 3.52
                                )
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .padding(.top)
                    .background(.white)
                    .scrollIndicators(.hidden)
                    .frame(width: UIScreen.main.bounds.width)
                }

            }
        }
        .padding(.top)
        .onAppear(
              perform: {
                  viewModel.fetchAllReceipts()
                  barcodeViewModel.fetchAllBarcode()
              }
          )
        .onChange(of: isSheetPresented){}
        .sheet(isPresented: $isSheetPresented, content: {
              if selectedIndex == 0 {
                  if let selectedReceipt = selectedReceipt {
                      MealAddDetailView(mealViewModel: mealViewModel, isSheetPresented: $isSheetPresented, receipt: selectedReceipt)
                          .presentationDetents([.height(UIScreen.main.bounds.height * 0.4)])
                          .presentationCornerRadius(50)
                          
                          
                  }
              } else if selectedIndex == 1 {
                  if let selectedBarcode = selectedBarcode {
                      MealAddReadyDetailView(addMealList: mealViewModel, isSheetPresented: $isSheetPresented, barcode: selectedBarcode)
                         .presentationDetents([.height(UIScreen.main.bounds.height * 0.65)])
                         .presentationCornerRadius(50)
                          
                          
                  }
              }
          })
    }
}

#Preview {
    MealAddView(mealViewModel: MealViewModel())
}
