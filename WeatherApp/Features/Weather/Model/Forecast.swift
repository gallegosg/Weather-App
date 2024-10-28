//
//  Forecast.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 10/9/24.
//

import Foundation

// MARK: - ForecastClass
struct Forecast: Codable {
    let forecastDay: [ForecastDay]
    
    enum CodingKeys: String, CodingKey {
        case forecastDay = "forecastday"
    }
}

// MARK: - ForecastDay
struct ForecastDay: Codable, Identifiable {
    let id = UUID()
    let date: String
    let dateEpoch: Int
    let day: Day
    let hour: [Hour]
    
    var highAndLowF: (String, String) {
        var high: Double = 0
        var low: Double = 0
        for h in hour {
            high = max(high, h.tempF)
            low = min(low, h.tempF)
        }
        return (String(high), String(low))
    }
    
    var highAndLowC: (String, String) {
        var high: Double = 0
        var low: Double = 0
        for h in hour {
            high = max(high, h.tempC)
            low = min(low, h.tempC)
        }
        return (String(high), String(low))
    }
    
    func highAndLow(for unit: String) -> (String, String) {
        return unit == K.imperial ? highAndLowF : highAndLowC
    }
    
    var hoursLeft: [Hour] {
        return hour.filter({ $0.timeEpoch > (Date().timeIntervalSince1970 - 3600)})
    }

    enum CodingKeys: String, CodingKey {
        case date
        case dateEpoch = "date_epoch"
        case day, hour
    }
}

// MARK: - Day
struct Day: Codable {
    let maxtempC, maxtempF, mintempC, mintempF: Double
    let avgtempC, avgtempF, maxwindMph, maxwindKph: Double
    let totalprecipMm, totalprecipIn, totalsnowCM, avgvisKM: Double
    let avgvisMiles, avghumidity, dailyWillItRain, dailyChanceOfRain: Double
    let dailyWillItSnow, dailyChanceOfSnow: Double
    let condition: Condition
    let uv: Double

    enum CodingKeys: String, CodingKey {
        case maxtempC = "maxtemp_c"
        case maxtempF = "maxtemp_f"
        case mintempC = "mintemp_c"
        case mintempF = "mintemp_f"
        case avgtempC = "avgtemp_c"
        case avgtempF = "avgtemp_f"
        case maxwindMph = "maxwind_mph"
        case maxwindKph = "maxwind_kph"
        case totalprecipMm = "totalprecip_mm"
        case totalprecipIn = "totalprecip_in"
        case totalsnowCM = "totalsnow_cm"
        case avgvisKM = "avgvis_km"
        case avgvisMiles = "avgvis_miles"
        case avghumidity
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case dailyWillItSnow = "daily_will_it_snow"
        case dailyChanceOfSnow = "daily_chance_of_snow"
        case condition, uv
    }
}

// MARK: - Hour
struct Hour: Codable, Identifiable {
    let id = UUID()
    let timeEpoch: Double
    
    let time: String
    
    var timeHour: String {
        let timeInterval: TimeInterval = timeEpoch

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        let date = Date(timeIntervalSince1970: timeInterval)
        let timeString = formatter.string(from: date)

        return timeString
    }
    
    let tempC, tempF: Double
    let isDay: Int
    let condition: Condition
    let windMph, windKph: Double
    let windDegree: Double
    let windDir: String
    let pressureMB: Double
    let pressureIn: Double
    let precipMm, precipIn, snowCM, humidity: Double
    let cloud: Double
    let feelslikeC, feelslikeF, windchillC, windchillF: Double
    let heatindexC, heatindexF, dewpointC, dewpointF: Double
    let willItRain, chanceOfRain, willItSnow, chanceOfSnow: Double
    let visKM, visMiles: Double
    let gustMph, gustKph, uv: Double
    
    func temperature(for unit: String) -> String {
        let temp = unit == K.imperial ? tempF : tempC
        return String(format: "%.0f° %@", temp, unit)
    }

    enum CodingKeys: String, CodingKey {
        case timeEpoch = "time_epoch"
        case time
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
        case snowCM = "snow_cm"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case willItRain = "will_it_rain"
        case chanceOfRain = "chance_of_rain"
        case willItSnow = "will_it_snow"
        case chanceOfSnow = "chance_of_snow"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
        case uv
    }
}

