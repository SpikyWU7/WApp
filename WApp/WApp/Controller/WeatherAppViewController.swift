//
//  ViewController.swift
//  WApp
//
//  Created by Spiky WU7 on 04.04.2022.
//

import UIKit

//TextFieldDelegate for allowing the class to manage editing and validation of text, in this case, with button "Go/Return" on software keyboard
final class WeatherAppViewController: UIViewController, UITextFieldDelegate {
    
    //IBOutlets for functional pieces of view
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    
    var textImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //textfield will report back to VC about user interactions
        searchTextField.delegate = self
    }
    
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
        searchTextField.text = ""
    }
    
}

