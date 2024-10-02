//
//  SideMenuHeader.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//

import SwiftUI

struct SideMenuHeader: View {
    var body: some View {
        HStack {
            Image(systemName: "sun.max.fill")
                .imageScale(.medium)
                .foregroundColor(.white)
                .frame(width: 30, height: 30)
                .background(.blue)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Favorites")
                    .font(.headline)
                    .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    SideMenuHeader()
}
