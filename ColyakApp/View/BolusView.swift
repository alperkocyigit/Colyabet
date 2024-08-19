//
//  BolusView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import PopupView

struct SettingsView: View {
    @StateObject var foodList = MealViewModel()
    @ObservedObject var sharedData = SharedData.shared
    @State var selectedDate = Date()
    @State var bloodGlucose = ""
    @State var targetBloodGlucose = ""
    @State var insulinCarbRatio = ""
    @State var idf = ""
    @Binding var result: Double
    @State var isVisible = false
    @Binding  var isShowing :Bool
    @State var buttonActivity:Bool = true
    @FocusState var focusedField:Field?
    
    var body: some View {
        ScrollView{
            VStack(spacing: 25) {
                Spacer()
                VStack{
                    HStack{
                        Text("Yemeği yediğiniz zaman")
                            .lineLimit(1)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.leading, 5)
                            .padding(.bottom,7)
                            .padding(.top)
                            .padding(.horizontal,8)
                        Spacer()
                    }
                    DatePicker("Select a Date",
                               selection: $selectedDate,
                               displayedComponents: [.date]
                    )
                    .onTapGesture(count: 99) {}
                    .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                    .environment(\.locale, Locale(identifier: "tr_TR"))
                    .datePickerStyle(.graphical)
                    .padding([.horizontal])
                    .background(Color.orange.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .cornerRadius(12)
                    
                    DatePicker("Saati seçin:",
                               selection: $selectedDate,
                               displayedComponents: [.hourAndMinute]
                    )
                    .environment(\.locale, Locale(identifier: "tr_TR"))
                    .datePickerStyle(.compact)
                    .padding()
                    .bold()
                    .background(Color.orange.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    .cornerRadius(12)
                    
                    VStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white)
                                .shadow(color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.10), radius: 10, y: 2)
                            
                            VStack {
                                Text("Seçtiğiniz Tarih ve Saat Gösterimi")
                                    .font(.system(size: 14))
                                    .bold()
                                    .foregroundColor(.black)
                                    .padding(.vertical, 8)
                                    .lineLimit(1)
                                
                                Divider()
                                    .padding(.horizontal)
                                
                                VStack {
                                    HStack {
                                        Image(systemName: "calendar")
                                            .foregroundColor(.orange)
                                        Text("Tarih:")
                                            .font(.callout)
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(formattedDateTime(selectedDate))
                                            .font(.callout)
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    
                                    Divider()
                                        .padding(.horizontal)
                                    
                                    HStack {
                                        Image(systemName: "clock")
                                            .foregroundColor(.orange)
                                        Text("Saat:")
                                            .font(.callout)
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Text(formattedClockTime(selectedDate))
                                            .font(.callout)
                                            .foregroundColor(.black)
                                    }
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 150)
                    .padding(.bottom, 10)
                    .padding(.top)
                    
                    VStack{
                        HStack{
                            Spacer()
                            Text("Yemeği tükettiğiniz tarih ve saat")
                                .lineLimit(1)
                                .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                                .fontWeight(.semibold)
                                .font(.system(size: 14))
                                .padding(.leading, 5)
                                .padding(.bottom,8)
                            Spacer()
                        }
                    }
                    .padding(.top)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding()
                .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(
                    color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.10), radius: 60, y: 4
                  ))
                
                CardView(explanation: "Açlık Kan Şekeri", imageName: "kan şekeri", title: "Kan Şekeri") {
                    TextField("Kan şekeri", text: $bloodGlucose)
                        .padding()
                        .keyboardType(.numberPad)
                        .focused($focusedField,equals: .bloodGlucose)
                        .tint(.black)
                        .toolbar{
                            ToolbarItemGroup(placement: .keyboard) {
                                if focusedField == .bloodGlucose {
                                    Spacer()
                                    Button("Sonraki değer") {
                                        focusedField = .targetBloodGlucose
                                    }
                                }else{
                                    if focusedField == .idf{
                                        Button("Önceki değer"){
                                            focusedField = .insulinCarbRatio
                                        }
                                        Spacer()
                                    }else{
                                        Button("Önceki değer"){
                                            switch focusedField {
                                            case .bloodGlucose:
                                                focusedField = nil
                                            case .targetBloodGlucose:
                                                focusedField = .bloodGlucose
                                            case .totalCarbohydrates:
                                                focusedField = .targetBloodGlucose
                                            case .insulinCarbRatio:
                                                focusedField = .totalCarbohydrates
                                            case .idf:
                                                focusedField = .insulinCarbRatio
                                            case nil:
                                                break
                                            }
                                        }
                                        Spacer()
                                        
                                        Button("Sonraki değer"){
                                            switch focusedField {
                                            case .bloodGlucose:
                                                focusedField = .targetBloodGlucose
                                            case .targetBloodGlucose:
                                                focusedField = .totalCarbohydrates
                                            case .totalCarbohydrates:
                                                focusedField = .insulinCarbRatio
                                            case .insulinCarbRatio:
                                                focusedField = .idf
                                            case .idf:
                                                focusedField = nil
                                            case nil:
                                                break
                                            }
                                        }
                                    }
                                }
                            }
                        }
                }
                CardView(explanation: "Doktorun Uygun Gördüğü Hedef Kan Şekeri", imageName: "hedef", title: "Hedef Kan Şekeri") {
                    TextField("Hedef kan şekeri", text: $targetBloodGlucose)
                        .padding()
                        .keyboardType(.numberPad)
                        .focused($focusedField,equals: .targetBloodGlucose)
                        .tint(.black)
                        
                }
                
                CardView(explanation: "Öğünde Alınan Karbonhidrat Miktarı", imageName: "karbonhidrat", title: "Karbonhidrat Miktarı") {
                    TextField("Karbonhidrat miktarı", text: $sharedData.totalCarbohydrates)
                        .padding()
                        .keyboardType(.numberPad)
                        .focused($focusedField,equals: .totalCarbohydrates)
                        .tint(.black)
                        
                }
                
                CardView(explanation: "İnsülün/Karbonhidrat Oranı", imageName: "yüzde", title: "İnsülün/Karbonhidrat Oranı") {
                    TextField("İnsülün/karbonhidrat oranı", text: $insulinCarbRatio)
                        .padding()
                        .keyboardType(.numberPad)
                        .focused($focusedField,equals: .insulinCarbRatio)
                        .tint(.black)
                        
                }
                
                CardView(explanation: "IDF()İnsülin Duyarlılık Faktörü", imageName: "insulin", title: "IDF (İnsülin Duyarlılık Faktörü)") {
                    TextField("IDF (İnsülin duyarlılık faktörü)", text: $idf)
                        .padding()
                        .keyboardType(.numberPad)
                        .focused($focusedField,equals: .idf)
                        .tint(.black)
                }
                
                Button(action: {
                    isVisible = true
                    isShowing = true
                    hideKeyboard()
                  
                    guard let carbohydrateValue = Double(sharedData.totalCarbohydrates),
                          let insulinCarbRatioValue = Double(insulinCarbRatio),
                          let bloodGlucoseValue = Double(bloodGlucose),
                          let targetBloodGlucoseValue = Double(targetBloodGlucose),
                          let idfValue = Double(idf) else {
                        return
                    }
                    
                    result = ((carbohydrateValue / insulinCarbRatioValue) + (bloodGlucoseValue - targetBloodGlucoseValue) / idfValue)
                    
                    print(result)

                    foodList.addMeal(food: foodList.food, bolus: Bolus(bloodSugar: Int(bloodGlucoseValue), targetBloodSugar: Int(targetBloodGlucoseValue), insulinTolerateFactor: Int(idfValue), totalCarbonhydrate: Int(carbohydrateValue), insulinCarbonhydrateRatio: Int(insulinCarbRatioValue), bolusValue: Int(result),eatingTime: dateJsonFormatter(selectedDate)))
                    
                }) {
                    Text("Hesapla")
                        .multilineTextAlignment(.center)
                        .frame(width: UIScreen.main.bounds.width * 0.8)
                        .padding()
                        .background(Color(red: 1, green: 0.48, blue: 0.22))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .cornerRadius(12)
                    
                   
                }
                .disabled(buttonActivity)
                .opacity(buttonActivity ? 0.5 : 1.0)
                .onReceive([bloodGlucose, targetBloodGlucose, sharedData.totalCarbohydrates, insulinCarbRatio, idf].publisher) { _ in
                    buttonActivity = (bloodGlucose.isEmpty || targetBloodGlucose.isEmpty || sharedData.totalCarbohydrates.isEmpty || insulinCarbRatio.isEmpty || idf.isEmpty)
                }
                HStack{
                    Text("\(result)")
                }
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.white)
           
        }
        .scrollIndicators(.hidden)
        
    }
}

struct CardView<Content: View>: View {
    var explanation:String
    var imageName: String
    var title: String
    var content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .lineLimit(1)
                .font(.headline)
                .fontWeight(.bold)
                .padding(.leading, 5)
                .padding(.bottom,7)
                .padding(.top)
                .padding(.horizontal,8)
            
            HStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30)
                    .padding(.leading)
                    .padding(.vertical)
                    
                content()
                    .foregroundColor(.black)
                    
            }
            .frame(height: 70)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(18)
            .padding(.bottom)
            .padding(.horizontal,8)
            
            HStack{
                Spacer()
                Text(explanation)
                    .lineLimit(1)
                    .foregroundColor(Color(red: 0.26, green: 0.26, blue: 0.26))
                    .fontWeight(.semibold)
                    .font(.system(size: 14))
                    .padding(.leading, 5)
                    .padding(.bottom,8)
                Spacer()
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.8)
        .padding()
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white).shadow(
            color: Color(red: 0.02, green: 0.02, blue: 0.06, opacity: 0.10), radius: 60, y: 4
          ))
        .padding(.horizontal)
    }
}

#Preview {
    SettingsView(result: .constant(15.0), isShowing: .constant(false))
}

private func formattedDateTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "tr_TR")
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter.string(from: date)
}

private func formattedClockTime(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "tr_TR")
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: date)
}

private func dateJsonFormatter(_ date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    return formatter.string(from: date)
}


enum Field: Hashable {
    case bloodGlucose
    case targetBloodGlucose
    case totalCarbohydrates
    case insulinCarbRatio
    case idf
}

