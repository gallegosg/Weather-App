//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/26/24.
//

import SwiftUI

struct LocationPermissionError: View {
    @State private var title: String = "No location access"
    @State private var error: String = "Please enable or select a new location."
    
    var body: some View {
        VStack(alignment: .center){
            Image(systemName: "location.slash")
                .resizable()
                .frame(width: 75, height: 75)
                .padding()
            Text(title)
                .font(.title)
            Text(error)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    LocationPermissionError()
}
