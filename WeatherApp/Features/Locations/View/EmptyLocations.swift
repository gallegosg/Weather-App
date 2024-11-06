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
            Text("No favorite locations")
                .font(.title)
            Text("Search up top to get started!")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
    }
}

#Preview {
    EmptyLocations()
}
