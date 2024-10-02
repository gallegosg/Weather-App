//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/1/24.
//

import Foundation

class SettingsViewModel: ObservableObject {
    @Published var selectedUnit: String = "C"
}
