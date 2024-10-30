//
//  ContentView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = WeatherViewModel(service: WeatherService(), locationManager: LocationManager())
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        Group {
            if let hasInternet = networkManager.hasInternet, hasInternet {
                TabView(selection: $vm.selectedTab) {
                    WeatherTab(vm: vm)
                    .tabItem {
                        Label("Weather", systemImage: "sun.max.fill")
                    }
                    .tag(Tab.weather)
                    
                    
                    NavigationStack {
                        Locations(vm: vm, selectedTab: $vm.selectedTab)
                    }
                    .tabItem {
                        Label("Locations", systemImage: "list.dash")
                    }
                    .tag(Tab.locations)
                    
                    NavigationStack {
                        SettingsView(vm: vm)
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                    .tag(Tab.settings)
                }
            } else {
                NoInternetView()
            }
        }
        .background(Color.blue.opacity(0.1))
        .onAppear {
            networkManager.start()
        }
        .onChange(of: networkManager.hasInternet) { _, newValue in
            handleInternet(hasInternet: newValue)
        }
    }
    
    func handleInternet(hasInternet: Bool?) {
        if let hasInternet = hasInternet {
            if networkManager.isFirstOpen && hasInternet {
                vm.fetchCurrentLocation()
                Task {
                    await vm.getCurrentLocationWeather()
                }
            }
        }
        networkManager.setIsFirst(to: false)
    }
}


#Preview {
    ContentView()
        .environmentObject(SettingsViewModel())
}
