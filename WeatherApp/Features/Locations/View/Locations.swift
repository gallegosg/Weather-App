//
//  SideMenu.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//
//  BUG: When switching tabs, there is a leftover blank space where the keyboard used to be

import SwiftUI
import SwiftData

struct Locations: View {
    @StateObject var vm: WeatherViewModel
    @Environment(\.modelContext) private var context
    @Query private var favorites: [FavoriteLocation]
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedTab: Tab
    @State private var showAlert: Bool = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                Button(action: {
                    Task {
                        await handleLocationsCurrentLocationButton()
                    }
                }, label: {
                    CurrentLocationRow()
                })
                if favorites.count > 0 {
                    ForEach(favorites) { favorite in
                        Button(action: {
                            Task {
                                await vm.fetchWeather(for: "\(favorite.name),  \(favorite.region)")
                            }
                            selectedTab = .weather
                        }, label: {
                            LocationRow(location: favorite)
                        })
                        .foregroundStyle(.primary)
                    }
                } else {
                    EmptyLocations()
                    .frame(height: geo.size.height / 2)
                }
                
            }
            .padding()
            .background(Color.blue.opacity(0.1))
            .navigationTitle("Locations")
            .searchable(text: $vm.searchText, prompt: "Search for a location")
            .onSubmit(of: .search) {
                UIApplication.shared.endEditing()
                Task {
                    await vm.fetchWeather()
                }
            }
            .overlay {
                if vm.isLoading{
                    ZStack {
                        Color(white: 0, opacity: 0.75)
                        ProgressView().tint(.white)
                    }
                }
            }
            .alert(isPresented: $showAlert, content: { noPermissionsAlert() })
            .alert(isPresented: $vm.noLocationFound, content: {noLocationsAlert() })
        }
    }
    
    func handleLocationsCurrentLocationButton() async {
        //check auth status
        if vm.authorizationStatus == .denied {
            showAlert = true
        } else if vm.authorizationStatus == .authorizedAlways || vm.authorizationStatus == .authorizedWhenInUse {
            vm.fetchCurrentLocation()
            await vm.getCurrentLocationWeather()
        }
    }
    
    func noPermissionsAlert() -> Alert {
        Alert(
            title: Text("No Location Access"),
            message: Text("Please authorize location access in Settings"),
            dismissButton: .default(Text("Okay")))
    }
    
    func noLocationsAlert() -> Alert {
        Alert(
            title: Text("No Location found"),
            message: Text("Please search for another location"),
            dismissButton: .default(Text("Okay")))
    }
}

#Preview {
    Locations(vm: .init(service: WeatherService(), locationManager: LocationManager()), selectedTab: .constant(.locations))
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
