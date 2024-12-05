//
//  EmptyLocations.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/30/24.
//

import SwiftUI

struct EmptyLocations: View {
    var body: some View {
        VStack(alignment: .center){
            Spacer()
            Image(systemName: "moon.fill")
                .resizable()
                .frame(width: 75, height: 75)
                .padding()
            Text(String(localized: "No favorite locations"))
                .font(.title)
            Text(String(localized: "Star a location to see it here!"))
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    EmptyLocations()
}
