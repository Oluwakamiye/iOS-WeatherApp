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
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var viewFoundation: NSLayoutConstraint!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var lat : Double = 0.0
    var lon : Double = 0.0
    var areLabelsHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        //conditionImage.image = nil
//        temperatureLabel.text = ""
//        cityLabel.text = ""
//        humidityLabel.text = ""
//        windLabel.text = ""
//        maxTempLabel.text = ""
//        minTempLabel.text = ""
        hideOrShowLabels()
    }
    
    func hideOrShowLabels(){
        if !areLabelsHidden{
            print("Hiding")
            humidityLabel.isHidden = true
            windLabel.isHidden = true
            maxTempLabel.isHidden = true
            minTempLabel.isHidden = true
            //expandButton.image(for: .)
        } else{
            print("Expanding")
            humidityLabel.isHidden = false
            windLabel.isHidden = false
            maxTempLabel.isHidden = false
            minTempLabel.isHidden = false
        }
        areLabelsHidden = !areLabelsHidden
    }
    @IBAction func searchPressed(_ sender: Any) {
        getWeatherData(cityName: searchTextField.text!)
        searchTextField.endEditing(true)
    }
    
    func getWeatherData(cityName : String){
        weatherManager.fetchWeather(cityName: cityName)
    }
    
    @IBAction func expandPressed(_ sender: UIButton) {
        hideOrShowLabels()
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
        viewFoundation.constant = 10
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewFoundation.constant = 320
        !areLabelsHidden ? hideOrShowLabels() : nil
    }
}

//MARK: - WeatherManagerDelegate
extension ViewController: WeatherManagerDelegate{
    func didUpdateWeather(response: WeatherResponse) {
        print("\(response.weatherType)")
        DispatchQueue.main.async {
            self.conditionImage.image = UIImage(systemName: response.iconName)
            self.temperatureLabel.text = "\(response.temperatureString) "
            self.cityLabel.text = "\(response.cityName), \(response.country)"
            self.humidityLabel.text = "humidity:\(response.humidity)"
            self.minTempLabel.text = "min-temp:\(response.minTemperatureString)"
            self.maxTempLabel.text = "max-temp:\(response.maxTemperatureString)"
            self.windLabel.text = "wind:\(response.wind)"
        }
    }
}
