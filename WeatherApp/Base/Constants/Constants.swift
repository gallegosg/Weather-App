//
//  Constants.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import Foundation

enum K {
    static let baseURL = "https://api.weatherapi.com/v1/forecast.json?key=" + Config.weatherKey
    static let defaultUnit = "F"
    static let imperial = "F"

    //User Default Keys
    static let tempUnitKey = "unit"
}
