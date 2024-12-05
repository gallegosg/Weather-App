//
//  WeatherTab.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/27/24.
//

import SwiftUI

struct WeatherTab: View {
    @StateObject var vm: WeatherViewModel

    var body: some View {
        Group {
            if let loc = vm.location, let cw = vm.currentWeather, let forecast = vm.forecast {
                CurrentWeather(loc: loc, cw: cw, forecast: forecast, isCurrentLocation: vm.isCurrentLocation, vm: vm)
            } else if vm.isLoading {
                ProgressView()
            } else if !vm.hasLocationAuth {
                LocationPermissionError()
            } else if let error = vm.error {
                ErrorView(error: error)
            } else {
                Text(String(localized: ("No location selected.")))
            }
        }
        .onAppear {
            UIApplication.shared.endEditing()
            
            let appearance = UINavigationBarAppearance()
            appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.white,
                    .font: UIFont.boldSystemFont(ofSize: 20)
                ]
            
                UINavigationBar.appearance().standardAppearance = appearance
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    WeatherTab(vm: .init(service: WeatherService(), locationManager: LocationManager()))
        .environmentObject(SettingsViewModel())
}
