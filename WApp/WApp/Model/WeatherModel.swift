//
//  WeatherModel.swift
//  WApp
//
//  Created by Spiky WU7 on 21.04.2022.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double
    //Formatting temperature label
    var temperatureString: String {
        return String(format: "%.1f", temperature)
    }
    //Choosing a displayed icon based on weather id data from JSON
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt.rain"
        case 300...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow.fill"
        case 701...781:
            return "cloud.fill"
        case 800:
            return "sun.max"
        case 801...804:
            return "smoke.fill"
        default:
            return "sun.haze.fill"
        }
    }
}
