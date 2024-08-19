//
//  ColyakAppApp.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI

@main
struct ColyakAppApp: App {
    @StateObject var loginViewModel = LoginViewModel()
    @StateObject var networkMonitor = NetworkMonitor()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environmentObject(loginViewModel)
                .environmentObject(networkMonitor)
        }
    }
}
