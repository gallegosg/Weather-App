//
//  SideMenuCurrentLocationRow.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/27/24.
//

import SwiftUI

struct CurrentLocationRow: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "location.fill")
                .imageScale(.medium)
            Text("Current Location")
                .font(.subheadline)
            Spacer()
        }
        .padding(.leading)
    }
}

#Preview {
    CurrentLocationRow()
}
