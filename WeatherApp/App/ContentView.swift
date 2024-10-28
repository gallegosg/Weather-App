//
//  ContentView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = WeatherViewModel(service: WeatherService(), locationManager: LocationManager())
    
    var body: some View {
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
        .background(Color.blue.opacity(0.1))
        .onAppear {
            vm.handleFirstAppear()
        }
        .task {
            await vm.getCurrentLocationWeather()
        }
    }
}


#Preview {
    ContentView()
        .environmentObject(SettingsViewModel())
}
