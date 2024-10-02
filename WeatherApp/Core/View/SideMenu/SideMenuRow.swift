//
//  SideMenuRow.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//

import SwiftUI

struct SideMenuRow: View {
    var location: FavoriteLocation
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "mappin.and.ellipse")
                .imageScale(.large)
            Text("\(location.name), \(location.region)")
                .font(.subheadline)
            Spacer()
        }
        .padding(.leading)
        .frame(height: 40)
    }
}

#Preview {
    SideMenuRow(location: FavoriteLocation(name: "San Francisco, CA", region: "California", country: "US"))
}
