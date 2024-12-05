//
//  SearchView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 11/5/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject var vm: WeatherViewModel
    @Environment(\.isSearching) var isSearching

    var body: some View {
        ZStack {
            Color(UIColor.black).opacity(0.8)
            Color.blue.opacity(0.1)
        }
        .onChange(of: isSearching) { _, newValue in
            if !newValue {
                print("Searching cancelled")
                vm.isSearchOverlayActive = false
            }
        }
        .onTapGesture {
            vm.isSearchOverlayActive = false
        }
        .alert(isPresented: $vm.noLocationFound, content: {noLocationsAlert() })
    }
    
    func noLocationsAlert() -> Alert {
        Alert(
            title: Text(String(localized: "No Location found")),
            message: Text(String(localized: "Please search for another location")),
            dismissButton: .default(Text(String(localized: "Okay")))
        )
    }
}

#Preview {
    SearchView(vm: .init(service: WeatherService(), locationManager: LocationManager()))
}
