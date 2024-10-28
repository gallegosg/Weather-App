//
//  BadRequest.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 9/23/24.
//

import Foundation

struct BadRequest: Codable {
    let error: BadRequestError
}

// MARK: - Error
struct BadRequestError: Codable {
    let code: Int
    let message: String
}
