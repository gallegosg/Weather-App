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
            isLoading = false
        }
    }
    @Published var isLoading: Bool = false
    @Published var isCurrentLocation: Bool = false
    @Published var hasLocationAuth: Bool = false
    @Published var selectedTab: Tab = .weather
    @Published var noLocationFound: Bool = false
    
    @Published var isSearchOverlayActive = true

    init(service: WeatherService, locationManager: LocationManager){
        self.service = service
        self.locationManager = locationManager
        
        setupBindings()
    }
    
    func fetchWeather(for loc: String? = nil, isCurrentLocation: Bool = false) async {
        error = nil
        isLoading = true
        noLocationFound = false
        defer { isLoading = false }
        do {
            let weather = try await service.fetchCurrentWeather(for: (loc != nil) ? loc! : searchText)
            currentWeather = weather.current
            location = weather.location
            forecast = weather.forecast.forecastDay
            self.isCurrentLocation = isCurrentLocation
            searchText = ""
            isSearchOverlayActive = false
        } catch let error as WeatherError {
            switch error {
            case .locationNotFound:
                noLocationFound = true
            default:
                self.error = error.errorMessage
            }
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
    
    func handleAuthChange() {
        //switch case for each authorizationStatus state
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            hasLocationAuth = true
            isLoading = true
            locationManager.requestLocation()
        case .notDetermined:
            isLoading = true
        case .restricted:
            print("restricted")
        case .denied:
            hasLocationAuth = false
            isLoading = false
        default:
            print("default")
        }
    }
    
    func resetLocationFound() {
        noLocationFound = false
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
