//
//  WeatherConditions.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/25/24.
//

import Foundation
import SwiftUICore

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
    
    var color: (primary: Color, secondary: Color) {
        switch self {
        case .sunny:
            return (.yellow, .white)
        case .cloudy:
            return (.white, .white)
        case .overcast:
            return (.white, .white)
        case .mist:
            return (.white, Color(hex: 0x7A7A7A))
        case .rain:
            return (.white, Color(hex: 0x81CEFF))
        case .snow:
            return (.white, .blue)
        case .sleet:
            return (.white, .blue)
        case .freezingRain:
            return (.white, .blue)
        case .thunderstorm:
            return (.white, .yellow)
        case .fog:
            return (.white, .gray)
        case .icePellets:
            return (.white, .blue)
        case .unknown:
            return (.white, .white)
        }
    }
    
    var weatherGradients: [Color] {
        switch self {
        case .sunny: [.lightBlue, Color(hex: 0x058EB9), Color(hex: 0x036F90)]                   // Sunny: warm, bright tones
        case .cloudy: [Color(hex: 0x7A7A7A), Color(hex: 0x5E5E5E), Color(hex: 0x979797)]                     // Cloudy: soft, muted grays
        case .overcast: [.gray, Color(hex: 0x696969)]                    // Overcast: darker, consistent grays
        case .mist: [Color(hex: 0x7A7A7A), Color(hex: 0x5E5E5E), Color(hex: 0x979797)] // Mist: very light grays
        case .rain: [Color(hex:0x627E8A), Color(hex: 0x77939E), Color(hex: 0x4682B4)]                        // Rain: cool, deep blues
        case .snow: [Color(hex: 0x8EACB7), .gray]                      // Snow: bright, frosty whites
        case .sleet: [Color(hex: 0x75B3C9), Color(hex: 0x4682B4), .gray]         // Sleet: pale blue with gray
        case .freezingRain: [Color(hex: 0x88CCE4), Color(hex: 0x4682B4)]       // Freezing Rain: icy blue with gray
        case .thunderstorm: [Color(hex: 0x095C79), Color(hex: 0x540979), Color(hex: 0x737379)]              // Thunderstorm: dramatic blue to purple
        case .fog: [Color(hex: 0xAEAEAF), Color(hex: 0x858585), Color(hex: 0x696969)] // Fog: soft, hazy grays
        case .icePellets: [Color(hex: 0x53A7C3), .gray]                      // Ice Pellets: cold cyan with gray
        case .unknown: [.gray, .black]
        }
    }
}
