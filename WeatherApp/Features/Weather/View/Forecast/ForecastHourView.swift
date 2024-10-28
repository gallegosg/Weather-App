//
//  ForecastHourView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/9/24.
//

import SwiftUI

struct ForecastHourView: View {
    var hour: Hour
    @EnvironmentObject var settings: SettingsViewModel

    var body: some View {
        VStack {
            VStack {
                Text(hour.timeHour)
                    .font(.headline)
                
                hour.condition.image
                    .resizable()
                    .foregroundStyle(.teal, .orange)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 25)
                
                Text(hour.temperature(for: settings.selectedUnit))
                    .font(.system(size: 25))
            }
        }
        .frame(height: 100)
        .padding(.horizontal, 15)
    }
}

#Preview {
    ForecastHourView(hour: sampleHour)
}

let sampleHour = Hour(
    timeEpoch: 1680307200,
    time: "2023-04-01 12:00",
    tempC: 18.5,
    tempF: 65.3,
    isDay: 1,
    condition: Condition(text: "Partly Cloudy", icon: "//cdn.weather.com/icons/partly_cloudy.png", code: 1003),
    windMph: 5.2,
    windKph: 8.3,
    windDegree: 120,
    windDir: "ESE",
    pressureMB: 1012.3,
    pressureIn: 29.88,
    precipMm: 0.2,
    precipIn: 0.01,
    snowCM: 0.0,
    humidity: 78.0,
    cloud: 40.0,
    feelslikeC: 18.0,
    feelslikeF: 64.4,
    windchillC: 17.0,
    windchillF: 62.6,
    heatindexC: 19.0,
    heatindexF: 66.2,
    dewpointC: 13.0,
    dewpointF: 55.4,
    willItRain: 0.2,
    chanceOfRain: 30.0,
    willItSnow: 0.0,
    chanceOfSnow: 0.0,
    visKM: 10.0,
    visMiles: 6.2,
    gustMph: 10.5,
    gustKph: 16.9,
    uv: 5.0
)
