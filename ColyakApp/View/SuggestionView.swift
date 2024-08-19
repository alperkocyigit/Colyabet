//
//  SuggestionView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct SuggestionView: View {
    @StateObject var viewModel = SuggestionViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var ClickButton:Bool = true
    @ObservedObject var sharedViewModel = SharedViewModel()
    
    var body: some View {
        VStack(spacing:25){
            VStack {
                ZStack {
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "chevron.left")
                                .resizable()
                                .frame(width: 12, height: 20)
                               
                                .foregroundColor(.black)
                                .padding(.horizontal)
                        })
                        Spacer()
                    }
                    
                    Text("Öneri")
                        .font(.title)
                        .bold()
                        .foregroundColor(.black)
                      
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            
            VStack(spacing:20) {
                VStack {
                    Text("Yemek Tarifi Öneri Alanı")
                    HStack {
                        TextField("Eklenmesini istediğiniz yemek tarif ismi", text: $viewModel.suggestion)
                            .padding(.leading,5)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                            .disabled(viewModel.isSuggestionDisabled)
                    }
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width * 0.90, height: 70)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                    .cornerRadius(16)
                }
                .padding(.top)
                .padding(.bottom,20)
                
                VStack {
                    Text("Barkodlu Ürün Öneri Alanı")
                    HStack{
                        TextField("Barcode no", text: $viewModel.suggestionBarcode)
                            .padding(.leading,5)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                            .disabled(viewModel.isBarcodeDisabled)
                            .keyboardType(.numberPad)
                            .onReceive(viewModel.suggestionBarcode.publisher) { newValue in
                                if viewModel.suggestionBarcode.count > 13 {
                                    viewModel.suggestionBarcode = String(viewModel.suggestionBarcode.prefix(13))
                                }
                            }
                        
                        Text("|")
                            .bold()
                            .padding(.horizontal)
                        
                        TextField("Ürünün adı", text: $viewModel.productName)
                            .padding(.leading,5)
                            .font(Font.custom("Poppins", size: 14))
                            .foregroundColor(Color(red: 0.68, green: 0.64, blue: 0.65))
                            .disabled(viewModel.isBarcodeDisabled)
                            .onReceive(viewModel.suggestionBarcode.publisher) { newValue in
                                if viewModel.suggestionBarcode.count > 13 {
                                    viewModel.suggestionBarcode = String(viewModel.suggestionBarcode.prefix(13))
                                }
                            }
                         
                    }
                    .padding(.horizontal)
                    .frame(width: UIScreen.main.bounds.width * 0.90, height: 70)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                    .cornerRadius(16)
                    
                    
                    Button(action: {
                        if viewModel.suggestion.isEmpty{
                            viewModel.addSuggestionBarcode()
                            viewModel.suggestionBarcode = ""
                        }else{
                            viewModel.addSuggestion()
                            viewModel.suggestion = ""
                            
                        }
                    }, label: {
                        HStack{
                            Image(systemName: "paperplane.fill")
                                .resizable()
                                .frame(width: 24,height: 24)
                                .foregroundColor(.white)
                                .rotationEffect(.degrees(270))
                                .padding(.trailing,6)
                            Text("Gönder")
                                .font(.system(size: 15))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.4, height: 53)
                        .background( Color(red: 1, green: 0.48, blue: 0.22))
                        .cornerRadius(16)
                       
                    })
                    .alert(isPresented: $viewModel.sent) {
                        Alert(title: Text("Başarıyla Gönderildi"), dismissButton: .default(Text("Kapat")))
                    }
                    .opacity(ClickButton ? 0.5 : 1)
                    .disabled(ClickButton)
                    .onReceive([viewModel.suggestion,viewModel.suggestionBarcode].publisher, perform: { _ in
                        ClickButton = (viewModel.suggestion.isEmpty && viewModel.suggestionBarcode.isEmpty)
                    })
                    .shadow(
                        color: Color(red: 0.58, green: 0.68, blue: 1, opacity: 0.30), radius: 22, y: 10)
                    .padding(.top)

                }
                VStack(alignment:.leading,spacing:7){
                    Text("*Barkodlu ürün eklerken sadece isim göndermek isterseniz, yemek tarif alanından gönderebilirisiniz.Barkodlu ürünlerde sadece barkod gönderilebilir ama sadece ürün ismi gönderilemez.")
                        .font(.system(size: 13))
                        .fontWeight(.light)
                    Text("*Yapacağınız yemek tarifi isim önerileriniz araştırılıp,diyetisyen kontrolünde,uygun koşullarda test edilicektir.")
                        .font(.system(size: 13))
                        .fontWeight(.light)
                    Text("*İki öneriyi aynı anda gönderemezsiniz.Sırayla gönderebilirsiniz.")
                        .font(.system(size: 13))
                        .fontWeight(.light)
                        .padding(2)
                    Text("*Barcode ile yapacağınız önerilerinize daha kolay geri dönüş yapılabilir.")
                        .font(.system(size: 13))
                        .fontWeight(.light)
                        .padding(2)
                }
                .padding(.horizontal)
                .padding(.top)
            }
        
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.suggestionBarcode = sharedViewModel.barcodeValue
        }
    }
}

#Preview {
    SuggestionView(sharedViewModel: SharedViewModel())
}

