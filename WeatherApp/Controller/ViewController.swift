//
//  ViewController.swift
//  WeatherApp
//
//  Created by Oluwakamiye Akindele on 01/10/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController {
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var lat : Double = 0.0
    var lon : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        conditionImage.image = nil
        cityLabel.text = ""
        temperatureLabel.text = ""
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        getWeatherData(cityName: searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    func getWeatherData(cityName : String){
        weatherManager.fetchWeather(cityName: cityName)
    }
}

//MARK: - LocationManagerDelegate
extension ViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
            weatherManager.fetchWeather(longitude: lon, latitude: lat)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error is \(error)")
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        weatherManager.fetchWeather(longitude: lon, latitude: lat)
        searchTextField.endEditing(true)
    }
}

//MARK: - TextFieldDelegate
extension ViewController : UITextFieldDelegate{
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
}

//MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate{
    func didUpdateWeather(response: WeatherResponse) {
        print("\(response.weatherType)")
        DispatchQueue.main.async {
            self.conditionImage.image = UIImage(systemName: response.iconName)
            self.temperatureLabel.text = "\(response.temperatureString) "
            self.cityLabel.text = response.cityName
        }
    }
}
