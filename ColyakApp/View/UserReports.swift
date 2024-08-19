//
//  UserReports.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct UserReports: View {
    @StateObject var vm = UserReportsViewModel()
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var activeReport : Bool = false
    
    var body: some View {
        VStack(spacing: 25) {
            headerView
            
            datePickersView
            
            Button(action:{
                vm.fetchReports()
                activeReport = true
            }){
                Text("Ara")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            
            if activeReport {
                if vm.reports.isEmpty {
                    Text("Aradığınız tarihte rapor bulunamadı!")
                        .foregroundColor(.red)
                        .font(.system(size: 16))
                        .padding()
                        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                        .cornerRadius(10)
                } else {
                    List(vm.reports) { report in
                        reportRowView(report: report)
                    }
                    .padding()
                    .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var headerView: some View {
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
                
                Text("Kullanıcı Raporları")
                    .font(.title)
                    .bold()
                    .foregroundColor(.black)
            }
        }
        .frame(width: UIScreen.main.bounds.width)
    }
    
    private var datePickersView: some View {
        VStack(spacing: 10) {
            HStack {
                DatePicker("Başlangıç Tarihi", selection: $vm.selectionStartDate, displayedComponents: .date)
            }
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width * 0.90, height: 70)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(16)
            
            HStack {
                DatePicker("Bitiş Tarihi", selection: $vm.selectionEndDate, displayedComponents: .date)
            }
            .padding(.horizontal)
            .frame(width: UIScreen.main.bounds.width * 0.90, height: 70)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(16)
        }
    }
    
    private func reportRowView(report: UserReport) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Kullanıcı Adı
            if let userName = report.userName {
                Text("Kullanıcı Adı: \(userName)")
                    .font(.headline)
            } else {
                Text("Kullanıcı Adı: Bilinmiyor")
                    .font(.headline)
            }
            
            // Kan Şekeri
            if let bloodSugar = report.bolus?.bloodSugar {
                Text("Kan Şekeri: \(bloodSugar)")
                    .font(.subheadline)
            } else {
                Text("Kan Şekeri: Bilinmiyor")
                    .font(.subheadline)
            }
            
            // Hedef Kan Şekeri
            if let targetBloodSugar = report.bolus?.targetBloodSugar {
                Text("Hedef Kan Şekeri: \(targetBloodSugar)")
                    .font(.subheadline)
            } else {
                Text("Hedef Kan Şekeri: Bilinmiyor")
                    .font(.subheadline)
            }
            
            // Karbonhidrat
            if let totalCarbonhydrate = report.bolus?.totalCarbonhydrate {
                Text("Karbonhidrat: \(totalCarbonhydrate)")
                    .font(.subheadline)
            } else {
                Text("Karbonhidrat: Bilinmiyor")
                    .font(.subheadline)
            }
            
            // Yemek Zamanı
            if let eatingTime = report.bolus?.eatingTime {
                Text("Yemek Zamanı: \(formattedStringToDateAndHour(dateTimeString: eatingTime))")
                    .font(.subheadline)
            } else {
                Text("Yemek Zamanı: Bilinmiyor")
                    .font(.subheadline)
            }
            
            // Rapor Zamanı
            if let reportTime = report.dateTime {
                Text("Rapor Zamanı: \(formattedStringToDateAndHour(dateTimeString: reportTime))")
                    .font(.subheadline)
            } else {
                Text("Rapor Zamanı: Bilinmiyor")
                    .font(.subheadline)
            }
            
            // Besin Listesi
            if let foodResponseList = report.foodResponseList {
                if foodResponseList.isEmpty{
                    VStack(alignment: .leading, spacing: 10){
                        Text("Besin Listesi")
                            .font(.headline)
                            .padding(.bottom)
                        
                        Text("Besin Listesi Bulunamadı")
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .cornerRadius(10)
                    }
                   
                }else{
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Besin Listesi")
                            .font(.headline)
                        
                        ForEach(foodResponseList) { food in
                            VStack(alignment: .leading) {
                                if let foodType = food.foodType {
                                    Text("Yemek Türü: \(foodType)")
                                        .font(.subheadline)
                                } else {
                                    Text("Yemek Türü: Bilinmiyor")
                                        .font(.subheadline)
                                }
                                
                                if let foodName = food.foodName {
                                    Text("Yemek Adı: \(foodName)")
                                        .font(.subheadline)
                                } else {
                                    Text("Yemek Adı: Bilinmiyor")
                                        .font(.subheadline)
                                }
                                
                                if let carbonhydrate = food.carbonhydrate {
                                    Text("Karbonhidrat: \(carbonhydrate)")
                                        .font(.subheadline)
                                } else {
                                    Text("Karbonhidrat: Bilinmiyor")
                                        .font(.subheadline)
                                }
                            }
                            .padding(.leading, 10)
                            .background(Color(red: 0.9, green: 0.9, blue: 0.9))
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal, 10)
                    .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        .cornerRadius(10)
    }
}

struct UserReports_Previews: PreviewProvider {
    static var previews: some View {
        UserReports()
    }
}


