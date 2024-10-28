//
//  FavoriteItem.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/26/24.
//

import Foundation
import SwiftData

@Model
class FavoriteLocation: Identifiable {
    var id: String
    var name: String
    var region: String
    var country: String
    
    init(name: String, region: String, country: String) {
        self.id = UUID().uuidString
        self.name = name
        self.region = region
        self.country = country
    }
}
