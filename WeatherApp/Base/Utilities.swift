//
//  Utilities.swift
//  WeatherApp
//
//  Created by Gerardo Gallegos on 11/20/24.
//

import Foundation

func calculateTimeAgo(from date: Date) -> String {
    let now = Date()
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.minute, .hour, .day], from: date, to: now)
    
    if let days = components.day, days > 0 {
        return "\(days) day\(days == 1 ? "" : "s") ago"
    } else if let hours = components.hour, hours > 0 {
        return "\(hours) hour\(hours == 1 ? "" : "s") ago"
    } else if let minutes = components.minute, minutes > 0 {
        return "\(minutes) minute\(minutes == 1 ? "" : "s") ago"
    } else {
        return "just now"
    }
}
