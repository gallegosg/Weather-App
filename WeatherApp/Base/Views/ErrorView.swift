//
//  ErrorView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/26/24.
//

import SwiftUI

struct ErrorView: View {
    @State var error: String
    var body: some View {
        Text(String(localized: "Something went wrong"))
            .font(.headline)
        Text(error)
            .font(.subheadline)
            .multilineTextAlignment(.center)
    }
}

#Preview {
    ErrorView(error: "Invalid response")
}
