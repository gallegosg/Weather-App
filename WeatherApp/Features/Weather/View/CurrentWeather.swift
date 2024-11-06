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
    let forecast: [ForecastDay]
    let isCurrentLocation: Bool
    @Query var favorites: [FavoriteLocation]
    @Environment(\.modelContext) var context
    @StateObject var vm: WeatherViewModel
    @EnvironmentObject var settings: SettingsViewModel
    
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
                VStack {
                    Spacer()
                    cw.condition.image
                        .resizable()
                        .foregroundStyle(.teal, .orange)
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 175)
                    Text("\(cw.temperature(for: settings.selectedUnit))")
                        .font(.system(size: 60))
                        .bold()
                        .padding()
                    Spacer()
                    Spacer()
                }
                .frame(height: 350)
                
                Spacer()
                WeatherSectionContainer {
                    conditions
                }
            }
            WeatherSectionContainer {
                ForecastView(forecastDays: forecast)
            }
        }
        .padding(10)
        .scrollIndicators(.hidden)
        .background(Color.blue.opacity(0.1))
        .refreshable {
            Task {
                await vm.fetchWeather(for: "\(loc.name), \(loc.region)", isCurrentLocation: vm.isCurrentLocation)
            }
        }
        .overlay {
            ZStack {
                Color(white: 0, opacity: 0.75)
                VStack {
                    TextField("Search", text: $vm.searchText)
                    Text("test")
                    Spacer()
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
    CurrentWeather(loc: .dummy, cw: .dummy, forecast: [], isCurrentLocation: true, vm: WeatherViewModel(service: WeatherService(), locationManager: LocationManager()))
        .environmentObject(SettingsViewModel())
}

private extension CurrentWeather {
    var conditions: some View {
        VStack {
            VStack {
                Text(cw.condition.text)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)
                HStack {
                    Spacer()
                    VStack {
                        Text("Feels like \(cw.feelsLike(for: settings.selectedUnit))")
                            .padding(.bottom, 1)
                        Text("Wind \(cw.windSpeed(for: settings.selectedUnit))")
                    }
                    Spacer()
                    VStack {
                        Text("Humidity \(cw.humidity.formatted()) %")
                            .padding(.bottom, 1)
                        Text("Precipitation \(cw.precipitation(for: settings.selectedUnit))")
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

