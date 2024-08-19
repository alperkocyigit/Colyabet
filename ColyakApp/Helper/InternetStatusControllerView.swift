//
//  InternetStatusController.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 11.07.2024.
//

import SwiftUI

struct InternetStatusControllerView<Content:View>: View {
    @EnvironmentObject var networkMonitor: NetworkMonitor
    let content : () -> Content
    var body: some View {
        if networkMonitor.isConnected {
            content()
        }else {
            ContentUnavailableView("İnternet bağlantısı yok",
                systemImage: "wifi.exclamationmark", description: Text("Lütfen bağlantınızı kontrol edin ve tekrar deneyin.")
            )
        }
    }
}

