//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Oluwakamiye Akindele on 20/11/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import Foundation

struct WeatherManager{
    
    func fetchWeather(cityName : String) -> WeatherResponse{
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&APPID=35a917747c5372f9eafbfe2aef66de71&units=metric"
        print("URL given is::\(urlString)")
        let response = performRequest(urlString : urlString)
        return response
    }
    
    func performRequest(urlString : String) -> WeatherResponse{
        var weatherResponse = WeatherResponse()
        
        //1. Create a URL object
        if let url = URL(string: urlString){
            
            //2. Create a URL Session with a default cofiguration
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    print(error!)
                    return
                } else{
                    if let safeData = data{
                        print(String(data: safeData, encoding: .utf8))
                        let weatherData = self.parseJSON(dataString: safeData)
                        weatherResponse = self.generateResponse(rawWeatherData: weatherData)
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
        
        return weatherResponse
    }
    
    func parseJSON(dataString : Data) -> WeatherData{
        var decodedData = WeatherData()
        let decoder = JSONDecoder()
        do{
            decodedData = try decoder.decode(WeatherData.self, from: dataString)
        }
        catch{
            print(error)
        }
        return decodedData
    }
    
    func generateResponse(rawWeatherData : WeatherData) -> WeatherResponse{
        var response : WeatherResponse = WeatherResponse()
        response.cityName = rawWeatherData.name
        response.weatherConditionId = rawWeatherData.weather![0].id
        response.temperature = String(rawWeatherData.main.temp)
        response.weatherType = "\(rawWeatherData.weather![0].main), \(rawWeatherData.weather![0].description)"
        print("response is \(response)")
        return response
    }
}
