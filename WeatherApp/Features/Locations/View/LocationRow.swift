//
//  SideMenuRow.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//

import SwiftUI

struct LocationRow: View {
    var location: FavoriteLocation
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "mappin.and.ellipse")
                .imageScale(.large)
            Text("\(location.name), \(location.region)")
                .font(.subheadline)
            Spacer()
        }
        .frame(height: 40)
        .padding()
        .background(Color.white.opacity(0.2))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
    }
}

#Preview {
    LocationRow(location: FavoriteLocation(name: "San Francisco", region: "California", country: "US"))
}
