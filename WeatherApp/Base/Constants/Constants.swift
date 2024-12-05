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
    static let metric = "C"

    //User Default Keys
    static let tempUnitKey = "unit"
    
    //Info
    static let appEmail = "shastyapps@gmail.com"
    static let emailSubject = "Weather App Feedback"
    static let emailBody = "I would like to share some feedback about your app..."
}
