//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import Foundation
import CoreLocation
import Combine

class WeatherViewModel: ObservableObject {
    private let service: WeatherService
    private let locationManager: LocationManager
    private var cancellables = Set<AnyCancellable>()//TODO: Cancel
    
    @Published var errorMessage: String?
    @Published var state: State = .na
    @Published var searchText: String = ""
    @Published var showMenu: Bool = false
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    enum State {
        case na
        case loading
        case success(currentWeather: CurrentWeatherData, location: Location, isCurrentLocation: Bool)
        case failed(error: String)
    }
    
    init(service: WeatherService, locationManager: LocationManager){
        self.service = service
        self.locationManager = locationManager
        
        setupBindings()
    }
    
    private func setupBindings() {
        locationManager.$currentLocation
                    .sink { [weak self] location in
                        guard let self = self else { return }
                        self.currentLocation = location
                        Task {
                            await self.getCurrentLocationWeather()
                        }
                    }
                    .store(in: &cancellables)
        locationManager.$authorizationStatus
                    .sink { [weak self] location in
                        guard let self = self else { return }
                        self.authorizationStatus = location
                    }
                    .store(in: &cancellables)
    
    }
    
    func fetchWeather(for location: String? = nil, isCurrentLocation: Bool = false) async {
        await MainActor.run {
            self.state = .loading
        }
        do {
            let weather = try await service.fetchCurrentWeather(for: (location != nil) ? location! : searchText)
            await MainActor.run {
                self.state = .success(currentWeather: weather.current, location: weather.location, isCurrentLocation: isCurrentLocation)
            }
        } catch let error as WeatherError {
            print("weather error: ", error.errorMessage)
            await MainActor.run {
                self.state = .failed(error: error.errorMessage)
            }
        } catch {
            print("generic error: ", error)
            await MainActor.run {
                self.state = .failed(error: error.localizedDescription)
            }
        }
    }
    
    func getCurrentLocationWeather() async {
        if let lat = currentLocation?.coordinate.latitude, let lon = currentLocation?.coordinate.longitude {
            await fetchWeather(for: "\(lat), \(lon)", isCurrentLocation: true)
        }
    }
    
    func fetchCurrentLocation() {
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            self.state = .loading
        }
        locationManager.requestLocation()
    }
}
