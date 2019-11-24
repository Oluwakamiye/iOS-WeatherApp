//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oluwakamiye Akindele on 01/10/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, WeatherManagerDelegate {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherManager.delegate = self
        
        searchTextField.delegate = self
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        getWeatherData(cityName: searchTextField.text!)
        searchTextField.endEditing(true)
        
    }
    
    //When you press GO on the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        getWeatherData(cityName: searchTextField.text!)
        //This line triggers the end editing method
        searchTextField.endEditing(true)
        print("Go button just pressed")
        return false
    }
    
    //Takes textField from editing mode to non-editing mode. is triggered when endEditing is true
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        } else {
            textField.placeholder = "Please type something"
            return false
        }
    }
    
    //What should happen when text field is done editing. is triggered when endEditing is true
    func textFieldDidEndEditing(_ textField: UITextField) {
        //searchTextField.text = ""
        textField.text = ""
    }
    
    func getWeatherData(cityName : String){
        weatherManager.fetchWeather(cityName: cityName)
    }
    
    func didUpdateWeather(response: WeatherResponse) {
        print("\(response.weatherType)")
        DispatchQueue.main.async {
            self.conditionImage.image = UIImage(systemName: response.iconName)
            self.temperatureLabel.text = "\(response.temperatureString) ℃"
            self.cityLabel.text = response.cityName
        }
    }
}
