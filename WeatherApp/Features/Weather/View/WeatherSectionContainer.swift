//
//  WeatherSectionContainer.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/11/24.
//

import SwiftUI

struct WeatherSectionContainer<Content: View>: View {
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
//            HStack {
//                Spacer()
//            }
            content
                .padding()
        }
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.vertical, 5)
    }
}
    
    #Preview {
        WeatherSectionContainer {
            VStack {
                Text("Hello, World!")
                    .font(.headline)
                Text("This is inside the container")
                .font(.subheadline)
        }
        .padding()
    }
}
