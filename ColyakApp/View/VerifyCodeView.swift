//
//  VerifyCodeView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

struct VerifyCodeView: View {
    @Binding var otpFields:[String]
    @Binding var isCodeCorrect:Bool
    @Binding var isCodeChecked: Bool
    @FocusState var activeField:OTPField?
    var body: some View {
        VStack {
            HStack(spacing:8){
                ForEach(0..<6,id: \.self){ index in
                    VStack(spacing:8){
                        ZStack{
                            Rectangle()
                                .fill(isCodeCorrect ? .gray : (isCodeChecked && !isCodeCorrect ? .red : (activeField == activeStateForIndex(index: index) ? .orange : .gray.opacity(0.2))))
                                .frame(height: 80)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 2)
                                        
                                )
                             
                                
                                
                            TextField("", text: $otpFields[index])
                                .textContentType(.oneTimeCode)
                                .multilineTextAlignment(.center)
                                .focused($activeField,equals: activeStateForIndex(index: index))
                        }
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width - 40)
        }
        .onChange(of: otpFields){ newValue in
            OTPCondition(value: newValue)
        }
    }
    
    func OTPCondition(value:[String]){
        for index in 0..<5{
            if value[index].count == 1 && activeStateForIndex(index: index) == activeField{
                activeField = activeStateForIndex(index: index + 1)
            }
        }
        for index in 1...5 {
            if value[index].isEmpty && !value[index - 1].isEmpty{
                activeField = activeStateForIndex(index: index - 1)
            }
        }
        for index in 0..<6{
            if value[index].count > 1 {
                otpFields[index] = String(value[index].last!)
                print("\(String(value[index]))")
            }
        }
    }
}
#Preview {
    VerifyCodeView(otpFields: .constant(Array(repeating: "", count: 6)), isCodeCorrect: .constant(false), isCodeChecked: .constant(false))
}

func activeStateForIndex(index:Int) -> OTPField {
    switch index{
    case 0 : return .field1
    case 1 : return .field2
    case 2 : return .field3
    case 3 : return .field4
    case 4 : return .field5
    default : return .field6
    }
}

enum OTPField{
    case field1
    case field2
    case field3
    case field4
    case field5
    case field6
}
