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
                .imageScale(.large)
            Text(String(localized:"Current Location"))
                .font(.subheadline)
            Spacer()
        }
        .foregroundStyle(Color.lightBlue)
        .frame(height: 40)
        .padding()
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    CurrentLocationRow()
}
