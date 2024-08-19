//
//  NetworkHelper.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 10.07.2024.
//

import Foundation
import Network

class NetworkMonitor:ObservableObject{
    private let networkMonitor = NWPathMonitor()
    private var workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task{
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
}
