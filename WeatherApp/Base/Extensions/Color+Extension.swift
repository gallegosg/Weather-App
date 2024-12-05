//
//  Color+Extension.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 11/12/24.
//

import Foundation
import SwiftUICore

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
}
