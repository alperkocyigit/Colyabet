//
//  DateFormatter.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 13.07.2024.
//

import Foundation

func formattedStringToDateAndHour(dateTimeString:String) -> String{
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    guard let date = dateFormatter.date(from: dateTimeString) else { return "Invalid Date" }
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "dd/MM/yyyy HH:mm"
    return outputFormatter.string(from: date)
}


func formattedStringToDate(dateTimeString:String) -> String{
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    guard let date = dateFormatter.date(from: dateTimeString) else { return "Invalid Date" }
    let calendar = Calendar.current
    let now = Date()
    let components = calendar.dateComponents([.second, .minute, .hour, .day, .weekOfYear, .month, .year], from: date, to: now)
    
    if let year = components.year, year >= 2 {
        return "\(year) yıl önce"
    } else if let year = components.year, year >= 1 {
        return "Geçen yıl"
    } else if let month = components.month, month >= 2 {
        return "\(month) ay önce"
    } else if let month = components.month, month >= 1 {
        return "Geçen ay"
    } else if let weekOfYear = components.weekOfYear, weekOfYear >= 2 {
        return "\(weekOfYear) hafta önce"
    } else if let weekOfYear = components.weekOfYear, weekOfYear >= 1 {
        return "Geçen hafta"
    } else if let day = components.day, day >= 2 {
        return "\(day) gün önce"
    } else if let day = components.day, day >= 1 {
        return "Dün"
    } else if let hour = components.hour, hour >= 2 {
        return "\(hour) saat önce"
    } else if let hour = components.hour, hour >= 1 {
        return "Bir saat önce"
    } else if let minute = components.minute, minute >= 2 {
        return "\(minute) dakika önce"
    } else if let minute = components.minute, minute >= 1 {
        return "Bir dakika önce"
    } else if let second = components.second, second >= 3 {
        return "\(second) saniye önce"
    } else {
        return "Şimdi"
    }
}
