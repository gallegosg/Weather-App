//
//  NoInternetView.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/28/24.
//

import SwiftUI

struct NoInternetView: View {
    var body: some View {
        VStack(alignment: .center){
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 75, height: 75)
                .padding()
            Text("No Internet Connection")
                .font(.title)
            Text("Please check your internet connection and try again.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
}

#Preview {
    NoInternetView()
}
