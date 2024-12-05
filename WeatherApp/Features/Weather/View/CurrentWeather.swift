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
    @State private var isSearchFieldFocused: Bool = true
    @State private var timeAgo: String = ""
    
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
        GeometryReader { geo in
            ScrollView {
                Text(String(localized: "Last updated \(timeAgo)"))
                    .font(.caption2)
                    .foregroundStyle(Color(hex: 0xE4E4E4))
                    .padding(.bottom, 5)
                ZStack {
                    if WeatherCondition.from(code: cw.condition.code) == WeatherCondition.snow {
                        ForEach(0..<20){_ in
                            SnowflakeView()
                        }
                    }
                    VStack {
                        VStack {
                            cw.condition.image
                                .resizable()
                                .foregroundStyle(cw.condition.iconColor.0, cw.condition.iconColor.1)
                                .aspectRatio(contentMode: .fit)
                                .frame(height: geo.size.height / 8)
                            Text("\(cw.temperature(for: settings.selectedUnit))")
                                .font(.system(size: geo.size.height / 15))
                                .bold()
                                .padding(.top, 5)
                                .padding(.bottom, 10)
                        }
                        
                        WeatherSectionContainer {
                            conditions
                        }
                        WeatherSectionContainer {
                            ForecastView(forecastDays: forecast, localTime: loc.localtime, epoch: loc.localtimeEpoch, timeZone: loc.tzID)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .scrollIndicators(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        vm.isSearchOverlayActive = true
                    }, label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.white)
                            .accessibilityLabel(String(localized: "Search"))
                    })
                }
                
                ToolbarItem(placement: .principal) {
                    VStack {
                        Text(loc.name)
                            .font(.headline)
                            .fontWeight(.heavy)
                        Text(loc.region)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        isFavorite ? removeFromFavorites() : addToFavorites()
                    }, label: {
                        Image(systemName: isFavorite ? "star.fill" : "star")
                            .accessibilityLabel(String(localized: "Favorite"))
                    })
                }
            }
            .background(
                LinearGradient(gradient: Gradient(colors: cw.condition.gradients), startPoint: .top, endPoint: .bottom)
            )
            .refreshable {
                Task {
                    await vm.fetchWeather(for: "\(loc.name), \(loc.region)", isCurrentLocation: vm.isCurrentLocation)
                }
            }
            .onAppear {
                startTimer()
                updateTimeAgo()
                
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = UIColor(Color.gray.opacity(0.3))
                appearance.backgroundEffect = UIBlurEffect(style: .systemThinMaterialDark)
                
                UINavigationBar.appearance().standardAppearance = appearance
            }
            .overlay {
                if vm.isSearchOverlayActive {
                    SearchView(vm: vm)
                        .searchable(text: $vm.searchText, isPresented: $isSearchFieldFocused, prompt: String(localized: "Seattle, WA"))
                        .onSubmit(of: .search) {
                            Task {
                                await vm.fetchWeather()
                            }
                        }
                        .onAppear {
                            isSearchFieldFocused = true
                        }
                }
            }
        }
    }
    
    private func addToFavorites() {
        let newFavorite = FavoriteLocation(name: loc.name, region: loc.region, country: loc.country)
        
        context.insert(newFavorite)
    }
    
    private func removeFromFavorites() {
        if let favoriteLocation = favoriteLocation {
            context.delete(favoriteLocation)
        }
    }
    
    private func startTimer() {
            Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                updateTimeAgo()
            }
        }
        
        private func updateTimeAgo() {
            let dateString = cw.lastUpdated
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

            if let date = dateFormatter.date(from: dateString) {
                timeAgo = calculateTimeAgo(from: date)
            } else {
                print("Invalid date format")
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
            Text(cw.condition.text)
                .font(.title)
                .fontWeight(.semibold)
                .padding(.bottom, 5)
            HStack {
                Spacer()
                VStack {
                    VStack {
                        Text(String(localized: "Feels like"))
                            .font(.subheadline)
                            .bold()
                            .foregroundStyle(Color(hex: 0xE4E4E4))
                        Text(cw.feelsLike(for: settings.selectedUnit))
                            .font(.title2)
                    }
                    Spacer()
                        .frame(height: 20)
                    VStack {
                        Text(String(localized: "Wind"))
                            .font(.subheadline)
                            .foregroundStyle(Color(hex: 0xE4E4E4))
                            .bold()
                        Text("\(cw.windSpeed(for: settings.selectedUnit))")
                            .font(.title2)
                    }
                }
                Spacer()
                Spacer()
                Spacer()
                VStack {
                    VStack {
                        Text(String(localized: "Humidity"))
                            .font(.subheadline)
                            .foregroundStyle(Color(hex: 0xE4E4E4))
                            .bold()
                        Text("\(cw.humidity.formatted())%")
                            .font(.title2)
                    }
                    Spacer()
                        .frame(height: 20)
                    
                    VStack {
                        Text(String(localized: "Visibility"))
                            .font(.subheadline)
                            .foregroundStyle(Color(hex: 0xE4E4E4))
                            .bold()
                        Text(cw.visibility(for: settings.selectedUnit))
                            .font(.title2)
                    }
                }
                Spacer()
            }
        }
        .multilineTextAlignment(.leading)
    }
}


struct SnowflakeView: View {
    @State private var flakeYPosition: CGFloat = -CGFloat.random(in: 50...200)
    private let flakeSize: CGFloat = CGFloat.random(in: 2...20)
    private let flakeColor: Color = Color(
        red: Double.random(in: 0.6...1),
        green: Double.random(in: 0.7...1),
        blue: Double.random(in: 1...1),
        opacity: Double.random(in: 0.4...0.7)
    )
    private let animationDuration: Double = Double.random(in: 5...12)
    private let flakeXPosition: CGFloat = CGFloat.random(in: 0...UIScreen.main.bounds.width)

    var body: some View {
        Text("❄️")
            .font(.system(size: flakeSize))
            .foregroundColor(flakeColor)
            .position(x: flakeXPosition, y: flakeYPosition)
            .onAppear {
                withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                    flakeYPosition = UIScreen.main.bounds.height + 50
                }
            }
    }
}
