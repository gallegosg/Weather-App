//
//  UnitButton.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/1/24.
//

import SwiftUI

struct UnitButton: View {
    let unit: String
    @EnvironmentObject var settings: SettingsViewModel
    
    var label: String {
        unit == "C" ? String(localized: "Celcius (°C)") : String(localized: "Fahrenheit (°F)")
    }

    var body: some View {
        HStack {
            Button(label) {
                settings.selectedUnit = unit
            }
            .foregroundStyle(.primary)
            Spacer()
            if settings.selectedUnit == unit {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.lightBlue)
            }
        }
    }
}

#Preview {
    UnitButton(unit: "C")
        .environmentObject(SettingsViewModel())
}
