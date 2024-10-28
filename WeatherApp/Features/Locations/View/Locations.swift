//
//  SideMenu.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//

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
        ScrollView {
            Button(action: {
                Task {
                    await handleLocationsCurrentLocationButton()
                }
            }, label: {
                CurrentLocationRow()
            })
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
            .searchable(text: $vm.searchText, prompt: "Search for a location")
            .onSubmit(of: .search) {
                UIApplication.shared.endEditing()
                Task {
                    await vm.fetchWeather()
                }
            }
                    
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .navigationTitle("Locations")
        .alert(isPresented: $showAlert,
               content: { noPermissionsAlert() })
    }
    
    
    func addItem() {
        let item = FavoriteLocation(name: "San Francisco", region: "California", country: "United States of America")
        
        context.insert(item)
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
}

#Preview {
    Locations(vm: .init(service: WeatherService(), locationManager: LocationManager()), selectedTab: .constant(.locations))
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
