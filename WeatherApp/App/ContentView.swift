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
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.white
        appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialDark)
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        UITabBar.appearance().backgroundColor = UIColor(Color.gray.opacity(0.3))
    }
    
    var body: some View {
        Group {
            if let hasInternet = networkManager.hasInternet, hasInternet {
                ZStack {
                    TabView(selection: $vm.selectedTab) {
                        NavigationStack {
                            WeatherTab(vm: vm)
                        }
                        .tabItem {
                            Image(systemName: "sun.max.fill")
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .tag(Tab.weather)
                        .accessibilityLabel(String(localized:"Weather"))
                        .foregroundStyle(.white)

                        
                        NavigationStack {
                            Locations(vm: vm, selectedTab: $vm.selectedTab)
                        }
                        .tabItem {
                            Image(systemName: "star.fill")
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .tag(Tab.locations)
                        .accessibilityLabel(String(localized: "Favorites"))
                        
                        NavigationStack {
                            SettingsView(vm: vm)
                        }
                        .tabItem {
                            Image(systemName: "gear")
                        }
                        .ignoresSafeArea(.keyboard, edges: .bottom)
                        .tag(Tab.settings)
                        .accessibilityLabel(String(localized: "Settings"))

                    }
                }
            } else if networkManager.isFirstOpen {
                ProgressView()
            }
            else {
                NoInternetView()
            }
        }
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
