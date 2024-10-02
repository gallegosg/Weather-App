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
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FavoriteLocation.self)
    }
}
