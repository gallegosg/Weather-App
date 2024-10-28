//
//  UnitButton.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/1/24.
//

import SwiftUI

struct UnitButton: View {
    let selectedUnit: String
    let unit: String
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        Button(action: {
            settings.selectedUnit = unit
        }, label: {
            Text(unit)
                .padding(.all, 10)
                .foregroundStyle(selectedUnit == unit ? .white : .blue)
                .background(selectedUnit == unit ? .blue : .white)
        })
        .buttonStyle(.plain)
    }
}

#Preview {
    UnitButton(selectedUnit: "C", unit: "C")
}
