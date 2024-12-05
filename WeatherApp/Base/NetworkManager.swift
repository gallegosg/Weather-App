//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/28/24.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    @Published var hasInternet: Bool? = nil
    @Published var isFirstOpen: Bool = true
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    init() {
        handler()
    }
    
    //start monitorering network connectivity
    func start() {
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
    }
    
    //handle change in network connectivity
    func handler() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                Task { @MainActor in
                    self.hasInternet = true
                }
            } else {
                Task { @MainActor in
                    self.hasInternet = false
                }
            }
        }
    }
    
    //update isFirstOpen.
    //to know if we fetch users location and weather
    func setIsFirst(to newVal: Bool) {
        isFirstOpen = newVal
    }
}
