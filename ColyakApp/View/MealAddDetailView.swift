//
//  MealAddDetailView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import PopupView

struct MealAddDetailView: View {
    @ObservedObject var mealViewModel : MealViewModel
    @State private var selectedAmount = 1
    @State private var selectedAttributeIndex: Int? = nil
    @Binding var isSheetPresented:Bool
    let receipt: Receipt
    @State var isShowingSuccessful = false
    @State var isShowingUnsuccessful = false
    
    var body: some View {
        VStack {
            VStack{
                Text(receipt.receiptName ?? "")
                    .padding(.top)
                    .padding(.horizontal)
                    .lineLimit(1)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Divider()
                    .padding(.top,10)
                    .padding(.horizontal)
            }
            .padding(.horizontal)
            .padding(.top)
            
            Spacer()
            
            VStack {
                    HStack {
                        HStack {
                            VStack(alignment:.leading){
                                Text(receipt.receiptName ?? "")
                                    .foregroundColor(Color(red: 0.13, green: 0.10, blue: 0.15))
                                    .font(.system(size: 14))
                                    .lineLimit(3)
                                
                                ScrollView(.horizontal, showsIndicators: false){
                                    LazyHStack(content: {
                                        if let nutritionalValuesList = receipt.nutritionalValuesList{
                                            ForEach(nutritionalValuesList.indices, id: \.self) { index in
                                            Button(action: {
                                                selectedAttributeIndex = index
                                            }) {
                                                Text((nutritionalValuesList[index].type)!)
                                                    .font(.system(size: 12))
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(selectedAttributeIndex == index ? .white : Color(red: 1, green: 0.48, blue: 0.22))
                                                    .frame(width: UIScreen.main
                                                        .bounds.width * 0.25, height: 30)
                                                    .background(selectedAttributeIndex == index ? Color(red: 1, green: 0.48, blue: 0.22) : Color(red: 0.85, green: 0.85, blue: 0.85))
                                                    .cornerRadius(15)
                                                
                                                }
                                            }
                                        }
                                    })
                                }
                                .frame(height: 40)
                            }
                            .padding(.horizontal)
                        }
                        Spacer()
                        VStack(spacing:15) {
                            Button(action: {
                                increments()
                            }) {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundColor(.black)
                                    .frame(width: UIScreen.main
                                        .bounds.width * 0.075, height:  UIScreen.main
                                        .bounds.height * 0.03)
                                    .background(Color(red: 0.88, green: 0.88, blue: 0.88))
                                    .cornerRadius(4)
                            }
                            
                            .padding(.top)
                            
                            TextField("Enter Value", value: $selectedAmount, formatter: NumberFormatter())
                                .font(.system(size: 18))
                                .multilineTextAlignment(.center)
                                .keyboardType(.numberPad)
                                .frame(width: 65, height: 35)
                                .background(Color.white)
                                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 35, x: 20, y: 20)
                                
                            
                            Button(action: {
                                decrement()
                            }) {
                                Image(systemName: "minus")
                                    .resizable()
                                    .frame(width: 10, height: 1)
                                    .foregroundColor(.black)
                                    .frame(width: UIScreen.main
                                        .bounds.width * 0.075, height: UIScreen.main
                                        .bounds.height * 0.03)
                                    .background(Color(red: 0.88, green: 0.88, blue: 0.88))
                                    .cornerRadius(4)
                            }
                          
                            .padding(.bottom)
                        }
                    }
                    .padding(.horizontal)
                
            }
            .frame(width:UIScreen.main.bounds.width * 0.9 ,height: UIScreen.main
                .bounds.height * 0.15)
            .background(.white)
            .cornerRadius(20)
            .padding(.horizontal)
            .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.15), radius: 35, x: 20, y: 20)
            
            Spacer()
            
            VStack {
                HStack {
                    Button(action: {
                        isSheetPresented = false
                    }) {
                        Text("Vazgeç")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.width * 0.40, height: UIScreen.main.bounds.height * 0.075)
                            .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                            .cornerRadius(12)
                    }
                    Button(action: {
                        if selectedAttributeIndex == nil{
                            isShowingUnsuccessful = true
                        }else{
                            addToReadyFoodList()
                            isShowingSuccessful = true
                        }
                      
                    }) {
                        Text("Ekle")
                            .foregroundColor(.white)
                            .fontWeight(.semibold)
                            .frame(width: UIScreen.main.bounds.width * 0.40, height: UIScreen.main.bounds.height * 0.075)
                            .background(Color(red: 1, green: 0.48, blue: 0.22))
                            .cornerRadius(12)
                    }
                }
            }
            .padding(.bottom)
        }
        .frame(height: UIScreen.main.bounds.height * 0.40)
        .popup(isPresented: $isShowingSuccessful) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(Color.white)
                    .bold()
                Text("Başarıyla kaydedildi.")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .bold()
            }
            .padding(.vertical)
            .frame(minWidth: 0, maxWidth:UIScreen.main.bounds.width * 0.55)
            .background(.green)
            .cornerRadius(18)
           
              
              
               
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.gray.opacity(0.5))
                .autohideIn(2)
        }
        .popup(isPresented: $isShowingUnsuccessful) {
            HStack(alignment: .center, spacing: 12) {
                 Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color.white)
                    .bold()
                    
                 Text("Lütfen gramaj seçimi yapın.")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .bold()
                 
               }
                .padding(.vertical)
               .frame(minWidth: 0, maxWidth:UIScreen.main.bounds.width * 0.65)
               .background(.red)
               .cornerRadius(18)
            
               
        } customize: {
            $0
                .type(.floater())
                .position(.bottom)
                .animation(.spring())
                .closeOnTapOutside(true)
                .backgroundColor(.gray.opacity(0.5))
                .autohideIn(2)
        }

    }
    
    func increments() {
        selectedAmount += 1
    }
    
    func decrement() {
        if selectedAmount > 0 {
            selectedAmount -= 1
        }
    }
    
    
    func addToReadyFoodList() {
        guard let selectedAttributeIndex = selectedAttributeIndex else { return }
        let selectedItem = receipt.nutritionalValuesList?[selectedAttributeIndex]
        let totalCarbohydrate = Double(selectedAmount) * (selectedItem?.carbohydrateAmount ?? 0)
        let newItem = Food(foodId: receipt.id, foodType: FoodType.RECEIPT, carbonhydrate: Int(totalCarbohydrate), foodName: receipt.receiptName!)
        
        mealViewModel.food.append(newItem)
    }
}

struct MealAddDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let nutritionalValuesList: [NutritionalValuesList] = [
            NutritionalValuesList(
                id: 1,
                unit: 1,
                type: "",
                carbohydrateAmount: 1,
                proteinAmount: 1,
                fatAmount: 1,
                calorieAmount: 1
            )
        ]

        let receipt = Receipt(
            id: 1,
            receiptDetails: [],
            receiptItems: [ReceiptItem(id: 1, productName: "", unit: 1, type: "")],
            receiptName: "Alper",
            nutritionalValuesList: nutritionalValuesList,
            imageId: 1
        )

        return MealAddDetailView(mealViewModel: MealViewModel(), isSheetPresented: .constant(false), receipt: receipt)
    }
}
