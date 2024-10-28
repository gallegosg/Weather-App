//
//  SettingsViewModel.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/1/24.
//

import Foundation
import SwiftUI

class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel()

    private let defaults = UserDefaults.standard
    @Published var selectedUnit: String {
        didSet {
            defaults.set(selectedUnit, forKey: K.tempUnitKey)
        }
    }
    
    init() {
        selectedUnit = defaults.string(forKey: K.tempUnitKey) ?? K.defaultUnit
    }
    
    func setUnit(to unit: String) {
        selectedUnit = unit
        defaults.set(unit, forKey: K.tempUnitKey)
    }
}
