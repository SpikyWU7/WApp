//
//  WeatherManager.swift
//  WApp
//
//  Created by Spiky WU7 on 20.04.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

//Implementation of the openweather API to get the actual weather data
struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6239fd8eaded8b87d23052847349d930&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    //Fetch weather for specific city
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    //Fetch weather based on user's location
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //Creating a URL with optional binding as long as urlString is not nil
        if let url = URL(string: urlString) {
            //Creating a URLSession - default
            let session = URLSession(configuration: .default)
            //Giving session a data task with completion handler
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    //converting data to a string for readability
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //Starting a task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
            
            print(weather.conditionName)
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
