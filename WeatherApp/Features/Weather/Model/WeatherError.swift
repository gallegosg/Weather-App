//
//  WeatherErrors.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import Foundation

enum WeatherError: Error {
    case invalidURL
    case invalidResponse(error: String)
    case invalidData
    case failed
    case locationNotFound
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse(let error):
            return error
        case .invalidData:
            return "Invalid Data"
        case .failed:
            return "Request Failed"
        case .locationNotFound:
            return "Location Not Found"
        }
    }
}
