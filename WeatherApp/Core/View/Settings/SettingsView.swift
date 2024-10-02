//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/1/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm: WeatherViewModel
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        List {
            HStack {
                Text("Permissions")
                Spacer()
                Button("Settings") {
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
            }
            HStack {
                Text("Units")
                Spacer()
                HStack {
                    UnitButton(selectedUnit: settingsViewModel.selectedUnit, unit: "C")
                    UnitButton(selectedUnit: settingsViewModel.selectedUnit, unit: "F")
                }
                .background(Color.accentColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.blue, lineWidth: 2)
                )
            }
        }
        .navigationTitle("Settings")
        .onAppear {
            vm.showMenu = false
        }
    }
}

#Preview {
    SettingsView(vm: WeatherViewModel(service: WeatherService(), locationManager: LocationManager()))
}
