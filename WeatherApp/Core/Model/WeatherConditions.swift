//
//  WeatherConditions.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//

import Foundation

enum WeatherCondition {
    case sunny
    case cloudy
    case overcast
    case mist
    case rain
    case snow
    case sleet
    case freezingRain
    case thunderstorm
    case fog
    case icePellets
    case unknown

    static func from(code: Int) -> WeatherCondition {
        switch code {
        case 1000:
            return .sunny // Sunny, Clear
        case 1003:
            return .cloudy // Partly cloudy
        case 1006:
            return .cloudy // Cloudy
        case 1009:
            return .overcast // Overcast
        case 1030:
            return .mist // Mist
        case 1063, 1150, 1153, 1180...1195, 1240...1246, 1273, 1276:
            return .rain // Various types of rain
        case 1066, 1069, 1114, 1117, 1210...1225, 1255...1282:
            return .snow // Various types of snow
        case 1072, 1204...1207, 1249...1252:
            return .sleet // Sleet and freezing rain
        case 1087, 1273...1279:
            return .thunderstorm // Thundery outbreaks
        case 1135, 1147:
            return .fog // Fog, Freezing fog
        case 1237, 1261, 1264:
            return .icePellets // Ice pellets and showers of ice pellets
        default:
            return .unknown // Unhandled conditions
        }
    }

    var imageName: String {
        switch self {
        case .sunny:
            return "sun.max.fill"
        case .cloudy:
            return "cloud"
        case .overcast:
            return "cloud"
        case .mist:
            return "cloud.fog"
        case .rain:
            return "cloud.rain"
        case .snow:
            return "cloud.snow"
        case .sleet:
            return "cloud.sleet"
        case .freezingRain:
            return "cloud.sleet"
        case .thunderstorm:
            return "cloud.bolt"
        case .fog:
            return "cloud.fog"
        case .icePellets:
            return "cloud.snow"
        case .unknown:
            return "globe.americas.fill"
        }
    }
}
