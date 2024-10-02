//
//  SideMenu.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//

import SwiftUI
import SwiftData

struct SideMenu: View {
    @Binding var isShowing: Bool
    @StateObject var vm: WeatherViewModel
    @Environment(\.modelContext) private var context
    @Query private var favorites: [FavoriteLocation]
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack{
            if isShowing {
                Rectangle()
                    .opacity(0.1)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                HStack {
                    VStack(alignment: .leading, spacing: 20) {
                        SideMenuHeader()
                        Button(action: {
                            Task {
                                await vm.getCurrentLocationWeather()
                            }
                            isShowing.toggle()
                        }, label: {
                            SideMenuCurrentLocationRow()
                        })
                        ForEach(favorites) { favorite in
                            Button(action: {
                                Task {
                                    await vm.fetchWeather(for: "\(favorite.name),  \(favorite.region)")
                                }
                                isShowing.toggle()
                            }, label: {
                                SideMenuRow(location: favorite)
                            })
                            .foregroundStyle(.primary)
                        }
                        Spacer()
                        NavigationLink(destination: SettingsView(vm:vm)) {
                            Image(systemName: "gear")
                                .resizable()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(colorScheme == .dark ? Color(UIColor(red: 0.02, green: 0.02, blue: 0.02, alpha: 1.00)) : .white)
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .animation(.easeInOut, value: isShowing)
    }

    
    func addItem() {
        let item = FavoriteLocation(name: "San Francisco", region: "California", country: "United States of America")
        
        context.insert(item)
    }
}

#Preview {
    SideMenu(isShowing: .constant(true), vm: .init(service: WeatherService(), locationManager: LocationManager()))
}
