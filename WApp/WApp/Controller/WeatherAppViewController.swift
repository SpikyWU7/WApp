//
//  ViewController.swift
//  WApp
//
//  Created by Spiky WU7 on 04.04.2022.
//

import UIKit
import CoreLocation

class WeatherAppViewController: UIViewController {
    
    //IBOutlets for functional pieces of view
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    //Adding the WeatherManager(weather API) functionality from Model
    var weatherManager = WeatherManager()
    
    //getting an information about user location
    let locationManager = CLLocationManager()
    
    var textImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        //triggering user permission request
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        //textfield will report back to VC about user interactions
        searchTextField.delegate = self
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

//MARK: - UITextFieldDelegate

//TextFieldDelegate for allowing the class to manage editing and validation of text, in this case, with button "Go/Return" on software keyboard
extension WeatherAppViewController: UITextFieldDelegate {
    //IBAction for city search text field
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        //dismiss the keyboard after user pressed "return" or "search" button
        searchTextField.endEditing(true)
    }
    
    //asks the delegate about "return" button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    //starting the validation of what the user typed
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type the city name"
            return false
        }
    }
    
    //calls when any of the textfields are done editing
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Use searchtextfield.text - get a city name and get a weather for that city
        //Optionally unwrapping the searchTextField
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherAppViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherAppViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
