//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/1/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm: WeatherViewModel
    @EnvironmentObject private var settings: SettingsViewModel
    var units: [String] = ["C", "F"]
    
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
                    ForEach (units, id: \.self) { unit in
                        UnitButton(selectedUnit: settings.selectedUnit, unit: unit)
                    }
                }
                .background(Color.accentColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(.blue, lineWidth: 2)
                )
            }
        }
        .background(Color.blue.opacity(0.1))
        .scrollContentBackground(.hidden)
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(vm: WeatherViewModel(service: WeatherService(), locationManager: LocationManager()))
        .environmentObject(SettingsViewModel())
}
