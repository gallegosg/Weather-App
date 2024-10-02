//
//  ContentView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var vm = WeatherViewModel(service: WeatherService(), locationManager: LocationManager())
    var body: some View {
        NavigationStack {
            ZStack {
                switch vm.state {
                case .na:
                    Text("Search for a location")
                case .loading:
                    ProgressView()
                case .success(currentWeather: let cw, location: let loc, isCurrentLocation: let isCurrentLocation):
                    CurrentWeather(loc: loc, cw: cw, isCurrentLocation: isCurrentLocation, vm: vm)
                case .failed(error: let error):
                    Text(error)
                }
                SideMenu(isShowing: $vm.showMenu, vm: vm)
            }
            .onAppear {
                vm.fetchCurrentLocation()
            }
            .task {
                await vm.getCurrentLocationWeather()
            }
            .toolbar(vm.showMenu ? .hidden : .visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        vm.showMenu.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                    })
                }
            }
            
        }
        .searchable(text: $vm.searchText)
        .onSubmit(of: .search) {
            Task {
                await(vm.fetchWeather())
            }
        }
    }
}

#Preview {
    ContentView()
}
