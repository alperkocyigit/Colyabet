//
//  ViewExtension.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 11.07.2024.
//

import SwiftUI

extension View {
    func withInternetStatus() -> some View {
        InternetStatusControllerView {
            self
        }
    }
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
