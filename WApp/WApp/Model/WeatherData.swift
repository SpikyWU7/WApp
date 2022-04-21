//
//  WeatherData.swift
//  WApp
//
//  Created by Spiky WU7 on 21.04.2022.
//

import Foundation

//Getting data from JSON
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
