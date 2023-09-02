//
//  OpenWeatherModel.swift
//  Week4
//
//  Created by 권현석 on 2023/09/02.
//

import Foundation

//struct OpenWeather: Codable {
//    let weather: Weather
//    let main: Main
//}
//
//struct Weather: Codable {
//    let main: String
//}
//
//struct Main: Codable {
//    let temp: Double
//    let humidity: Int
//}

// MARK: - Weather
struct OpenWeather: Codable {
    let main: Main
    let weather: [WeatherElement]
}

struct WeatherElement: Codable {
    let main: String
}

// MARK: - Main
struct Main: Codable {
    let temp: Double
    let humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case humidity
    }
}
