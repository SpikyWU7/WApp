import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
}

struct WeatherManager {
    private let decoder = JSONDecoder()
    private let session = URLSession(configuration: .default)
    private let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=6239fd8eaded8b87d23052847349d930&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/weather"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: String(latitude)),
            URLQueryItem(name: "lon", value: String(longitude)),
            URLQueryItem(name: "appid", value: "6239fd8eaded8b87d23052847349d930"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en")]

        guard let urlWeather = urlComponents.url?.absoluteString else { return }
        performRequest(urlWeather)
    }
    
    private func performRequest(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            if let safeData = data, let weather = self.parseJSON(safeData) {
                self.delegate?.didUpdateWeather(self, weather: weather)
            }
        }
        task.resume()
    }
    
    private func parseJSON(_ weatherData: Data) -> WeatherModel? {
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch {
            return nil
        }
    }
}
