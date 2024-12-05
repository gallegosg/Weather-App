//
//  Forecast.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/9/24.
//

import SwiftUI

struct ForecastView: View {
    let forecastDays: [ForecastDay]
    let localTime: String
    let epoch: Int
    let timeZone: String
    var body: some View {
        VStack {
            Text(String(localized: "Today"))
                .fontWeight(.semibold)
                .font(.title)
            ScrollView(.horizontal) {
                HStack {
                    if let day = forecastDays.first {
                        ForEach(day.hoursLeft(for: localTime, epoch: epoch)) { hour in
                            ForecastHourView(hour: hour, timeZone: timeZone)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    ForecastView(forecastDays: [], localTime: "2024-11-24 21:36", epoch: 234234, timeZone: "America/Los_Angeles")
        .environmentObject(SettingsViewModel())
}
