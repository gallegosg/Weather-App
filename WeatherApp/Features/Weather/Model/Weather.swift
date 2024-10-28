//
//  Weather.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import Foundation
import SwiftUI

// MARK: - Weather
struct Weather: Codable {
    let location: Location
    let current: CurrentWeatherData
    let forecast: Forecast
}

// MARK: - Current
struct CurrentWeatherData: Codable {
    let lastUpdatedEpoch: Int
    let lastUpdated: String
    let tempC, tempF, isDay: Double
    let condition: Condition
    let windMph, windKph: Double
    let windDegree: Int
    let windDir: String
    let pressureMB: Double
    let pressureIn: Double
    let precipMm, precipIn, humidity, cloud: Double
    let feelslikeC, feelslikeF, windchillC, windchillF: Double
    let heatindexC, heatindexF, dewpointC, dewpointF: Double
    let visKM, visMiles, uv: Double
    let gustMph, gustKph: Double

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }
    
    func temperature(for unit: String) -> String {
        let temp = unit == K.imperial ? tempF : tempC
        return String(format: "%.0f° %@", temp, unit)
    }
    func feelsLike(for unit: String) -> String {
        let temp = unit == K.imperial ? feelslikeF : feelslikeC
        return String(format: "%.0f° %@", temp, unit)
    }
    func windSpeed(for unit: String) -> String {
        let wind = unit == K.imperial ? windMph : windKph
        let speed = unit == K.imperial ? "mph" : "kph"
        return String(format: "%.0f %@", wind, speed)
    }
    
    func precipitation(for unit: String) -> String {
        let prec = unit == K.imperial ? precipIn : precipMm
        let height = unit == K.imperial ? "in" : "mm"
        return String(format: "%.0f%@", prec, height)
    }
}

extension CurrentWeatherData {
    static let dummy = CurrentWeatherData(
        lastUpdatedEpoch: 1695462000,
        lastUpdated: "2024-09-23 11:00",
        tempC: 18.3,
        tempF: 64.9,
        isDay: 1,
        condition: Condition(
            text: "Partly Cloudy",
            icon: "//cdn.weatherapi.com/weather/64x64/day/116.png",
            code: 1003
        ),
        windMph: 10.0,
        windKph: 16.1,
        windDegree: 200,
        windDir: "SSW",
        pressureMB: 1012.0,
        pressureIn: 29.88,
        precipMm: 0.0,
        precipIn: 0.0,
        humidity: 78,
        cloud: 40,
        feelslikeC: 18.3,
        feelslikeF: 64.9,
        windchillC: 18.3,
        windchillF: 64.9,
        heatindexC: 18.3,
        heatindexF: 64.9,
        dewpointC: 14.2,
        dewpointF: 57.6,
        visKM: 10.0,
        visMiles: 6.2,
        uv: 5.0,
        gustMph: 12.5,
        gustKph: 20.1
    )
}


// MARK: - Condition
struct Condition: Codable {
    let text, icon: String
    let code: Int
    
    var image: Image {
        Image(systemName: WeatherCondition.from(code: code).imageName)
    }
}

// MARK: - Location
struct Location: Codable {
    let name, region, country: String
    let lat: Double
    let lon: Double
    let tzID: String
    let localtimeEpoch: Int
    let localtime: String

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

extension Location {
    static let dummy = Location(
        name: "San Francisco",
        region: "California",
        country: "USA",
        lat: 37.7749,
        lon: -122.4194,
        tzID: "America/Los_Angeles",
        localtimeEpoch: 1695465600,
        localtime: "2024-09-23 12:00"
    )
}
