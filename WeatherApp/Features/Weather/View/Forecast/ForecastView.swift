//
//  Forecast.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/9/24.
//

import SwiftUI

struct ForecastView: View {
    let forecastDays: [ForecastDay]
    var body: some View {
        VStack {
            Text("Today")
                .font(.title)
                .bold()
            ScrollView(.horizontal) {
                HStack {
                    if let day = forecastDays.first {
                        ForEach(day.hoursLeft) { hour in
                            ForecastHourView(hour: hour)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

#Preview {
    ForecastView(forecastDays: [])
}
