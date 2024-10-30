//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import Foundation

struct WeatherService {    
    func fetchCurrentWeather(for location: String) async throws -> Weather {
        let locationURL = K.baseURL + "&q=" + location
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
                throw WeatherError.invalidResponse(error: badRequest.error.message)
            }
            
            let weather = try JSONDecoder().decode(Weather.self, from: data)

            return weather
        }
        catch {
            throw error
        }
    }
}
