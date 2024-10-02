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
    var body: some View {
        Button(action: {
            print(unit)
        }, label: {
            Text(unit)
                .padding(.all, 5)
                .foregroundStyle(selectedUnit == unit ? .white : .blue)
                .background(selectedUnit == unit ? .blue : .white)
        })
    }
}

#Preview {
    UnitButton(selectedUnit: "C", unit: "C")
}
