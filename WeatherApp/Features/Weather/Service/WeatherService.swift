//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import Foundation

struct WeatherService {    
    func fetchCurrentWeather(for location: String) async throws -> Weather {
        let langStr = Locale.current.language.languageCode?.identifier ?? ""
        let locationURL = K.baseURL + "&q=" + location + "&lang=" + langStr
        guard let url = URL(string: locationURL) else {
            throw WeatherError.invalidURL
        }
        
        do {
            URLCache.shared.removeAllCachedResponses()
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResonse = response as? HTTPURLResponse else {
                throw WeatherError.invalidResponse(error: "Invalid response")
            }
            
            let errorRange = 400...499
            
            if errorRange.contains(httpResonse.statusCode)	 {
                let badRequest = try JSONDecoder().decode(BadRequest.self, from: data)
                if badRequest.error.code == 1006 {
                    throw WeatherError.locationNotFound
                } else {
                    throw WeatherError.invalidResponse(error: badRequest.error.message)
                }
            }
            
            let weather = try JSONDecoder().decode(Weather.self, from: data)

            return weather
        }
        catch {
            throw error
        }
    }
}
