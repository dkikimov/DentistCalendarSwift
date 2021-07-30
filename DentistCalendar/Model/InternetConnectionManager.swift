//
//  InternetConnection.swift
//  DentistCalendar
//
//  Created by Даник 💪 on 23.04.2021.
//

import Foundation
import SwiftUI
import Network
import ApphudSDK

class InternetConnectionManager: ObservableObject {
    @Published var isNotInternetConnected: Bool = false
    @Published var isInternetConnected: Bool = true
    var internetConnection: InternetConnectionType = .enabled
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global()
    init() {
        startMonitoring()
    }
    deinit {
        monitor.cancel()
    }
    private func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            if !Apphud.hasActiveSubscription() {
                if path.status == .satisfied {
                    print("We're connected!")
                    DispatchQueue.main.async {
                        self.isNotInternetConnected = false
                        self.isInternetConnected = true
                        self.internetConnection = .enabled
                    }
                } else {
                    print("No connection.")
                    DispatchQueue.main.async {
                        self.isNotInternetConnected = true
                        self.isInternetConnected = false
                        self.internetConnection = .disabled
                        
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.isNotInternetConnected = false
                    self.isInternetConnected = true
                    self.internetConnection = .enabled
                }
            }
            
        }
    }
    
    func isInternetEnabled() -> Bool {
        switch internetConnection {
        case .enabled:
            return true
        case .disabled:
            return false
        }
    }
}
