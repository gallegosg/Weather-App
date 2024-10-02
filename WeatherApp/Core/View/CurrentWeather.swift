//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//

import SwiftUI
import SwiftData
struct CurrentWeather: View {
    let loc: Location
    let cw: CurrentWeatherData
    let isCurrentLocation: Bool
    @Query var favorites: [FavoriteLocation]
    @Environment(\.modelContext) var context
    @StateObject var vm: WeatherViewModel
    
    private var favoriteLocation: FavoriteLocation? {
        for fav in favorites {
            if fav.name == loc.name && fav.region == loc.region && fav.country == loc.country {
                return fav
            }
        }
        return nil
    }
    
    private var isFavorite: Bool {
        if let _ = favoriteLocation {
            return true
        }
        return false
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    HStack {
                        Spacer()
                        if isCurrentLocation {
                            Image(systemName: "location.fill")
                        }
                        Text("\(loc.name), \(loc.region)")
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            isFavorite ? removeFromFavorites() : addToFavorites()
                        }, label: {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                        })
                    }
                    Spacer()
                    cw.condition.image
                        .resizable()
                        .foregroundStyle(.teal, .orange)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                    Spacer()
                    HStack {
                        Text("\(cw.tempF.formatted())° F")
                            .font(.system(size: 60))
                            .bold()
                            .padding()
                    }
                    VStack {
                        Text(cw.condition.text)
                            .font(.title3)
                            .padding(.bottom, 2)
                        Text("Feels like \(cw.feelslikeF.formatted())° F")
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
            .padding(.horizontal, 10)
            .background(Color.blue.opacity(0.1))
            .refreshable {
                Task {
                    await vm.fetchWeather(for: "\(loc.name), \(loc.region)")
                }
            }
        }
    }
    
    func addToFavorites() {
        let newFavorite = FavoriteLocation(name: loc.name, region: loc.region, country: loc.country)
        
        context.insert(newFavorite)
    }
    
    func removeFromFavorites() {
        if let favoriteLocation = favoriteLocation {
            context.delete(favoriteLocation)
        }
    }
}

#Preview {
    CurrentWeather(loc: location, cw: current, isCurrentLocation: true, vm: WeatherViewModel(service: WeatherService(), locationManager: LocationManager()))
}

let location = Location(
    name: "San Francisco",
    region: "California",
    country: "USA",
    lat: 37.7749,
    lon: -122.4194,
    tzID: "America/Los_Angeles",
    localtimeEpoch: 1695465600,
    localtime: "2024-09-23 12:00"
)
let current = CurrentWeatherData(
    lastUpdatedEpoch: 1695462000,
    lastUpdated: "2024-09-23 11:00",
    tempC: 18.3,
    tempF: 64.9,
    isDay: 1,
    condition: Condition(
        text: "Partly Cloudy",
        icon: "//cdn.weatherapi.com/weather/64x64/day/116.png",
        code: 1003
    ),
    windMph: 10.0,
    windKph: 16.1,
    windDegree: 200,
    windDir: "SSW",
    pressureMB: 1012.0,
    pressureIn: 29.88,
    precipMm: 0.0,
    precipIn: 0.0,
    humidity: 78,
    cloud: 40,
    feelslikeC: 18.3,
    feelslikeF: 64.9,
    windchillC: 18.3,
    windchillF: 64.9,
    heatindexC: 18.3,
    heatindexF: 64.9,
    dewpointC: 14.2,
    dewpointF: 57.6,
    visKM: 10.0,
    visMiles: 6.2,
    uv: 5.0,
    gustMph: 12.5,
    gustKph: 20.1
)
