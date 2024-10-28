//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import SwiftUI
import SwiftData

@main
struct WeatherAppApp: App {
    @StateObject var settings = SettingsViewModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(settings)
        }
        .modelContainer(for: FavoriteLocation.self)
    }
}
