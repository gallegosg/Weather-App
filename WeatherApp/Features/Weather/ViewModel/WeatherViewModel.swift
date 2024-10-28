//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import Foundation
import CoreLocation
import Combine

enum Tab {
  case weather, locations, settings
 }

@MainActor
class WeatherViewModel: ObservableObject {
    private let service: WeatherService
    
    @Published var searchText: String = ""
    
    //Location
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()//TODO: Cancel
    @Published var currentLocation: CLLocation? {
        didSet {
            Task {
                await getCurrentLocationWeather()
            }
        }
    }
    
    @Published var authorizationStatus: CLAuthorizationStatus? {
        didSet {
            handleAuthChange()
        }
    }
    
    @Published var currentWeather: CurrentWeatherData?
    @Published var location: Location?
    @Published var forecast: [ForecastDay]?
    @Published var error: String? {
        didSet {
            print(error)
            isLoading = false
        }
    }
    @Published var isLoading: Bool = false
    @Published var isCurrentLocation: Bool = false
    @Published var hasLocationAuth: Bool = false
    @Published var selectedTab: Tab = .weather
    
    init(service: WeatherService, locationManager: LocationManager){
        self.service = service
        self.locationManager = locationManager
        
        setupBindings()
    }
    
    func fetchWeather(for loc: String? = nil, isCurrentLocation: Bool = false) async {
        error = nil
        isLoading = true
        defer { isLoading = false }
        do {
            let weather = try await service.fetchCurrentWeather(for: (loc != nil) ? loc! : searchText)
            currentWeather = weather.current
            location = weather.location
            forecast = weather.forecast.forecastDay
            self.isCurrentLocation = isCurrentLocation
            selectedTab = .weather
        } catch let error as WeatherError { 
            self.error = error.errorMessage
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    func getCurrentLocationWeather() async {
        if let lat = currentLocation?.coordinate.latitude, let lon = currentLocation?.coordinate.longitude {
            await fetchWeather(for: "\(lat), \(lon)", isCurrentLocation: true)
        }
    }
    
    func fetchCurrentLocation() {
        isLoading = true
        locationManager.requestLocation()
    }
    
    func handleFirstAppear() {
        fetchCurrentLocation()
    }
    
    func handleAuthChange() {
        //switch case for each authorizationStatus state
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            hasLocationAuth = true
            isLoading = true
            locationManager.requestLocation()
        case .notDetermined:
            isLoading = true
            print("not determined")
        case .restricted:
            print("restricted")
        case .denied:
            hasLocationAuth = false
            isLoading = false
        default:
            print("default")
        }
    }
}

//MARK: - Setup Bindings
extension WeatherViewModel {
    private func setupBindings() {
        locationManager.$currentLocation
                    .sink { [weak self] location in
                        guard let self = self else { return }
                        self.currentLocation = location
                    }
                    .store(in: &cancellables)
        locationManager.$authorizationStatus
                    .sink { [weak self] location in
                        guard let self = self else { return }
                        self.authorizationStatus = location
                    }
                    .store(in: &cancellables)
        locationManager.$error
                    .sink { [weak self] e in
                        guard let self = self else { return }
                        self.error = e
                    }
                    .store(in: &cancellables)
    
    }
}
