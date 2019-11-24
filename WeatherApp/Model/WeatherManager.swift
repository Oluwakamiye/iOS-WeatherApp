//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Oluwakamiye Akindele on 20/11/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather (response : WeatherResponse)
}

struct WeatherManager{
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName : String){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&APPID=35a917747c5372f9eafbfe2aef66de71&units=metric"
        print("URL given is::\(urlString)")
        performRequest(urlString : urlString)
    }
    
    func performRequest(urlString : String){
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
                        //print(String(data: safeData, encoding: .utf8))
                        if let weatherResult = self.parseJSON(dataString: safeData){
                            self.delegate?.didUpdateWeather(response: weatherResult)
                            
                        }
                    }
                }
            }
            
            //4. Start the task
            task.resume()
        }
    }
    
    func parseJSON(dataString : Data) -> WeatherResponse?{
        do{
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(WeatherData.self, from: dataString)
            
            let weatherResponse = generateWeatherResponse(rawWeatherData: decodedData)
            return weatherResponse
        }
        catch{
            print(error)
            return nil
        }
    }
    
    func generateWeatherResponse(rawWeatherData : WeatherData) -> WeatherResponse{
        var response : WeatherResponse = WeatherResponse()
        response.cityName = rawWeatherData.name
        response.weatherConditionId = rawWeatherData.weather![0].id
        response.temperature = String(rawWeatherData.main.temp)
        response.weatherType = "\(rawWeatherData.weather![0].main), \(rawWeatherData.weather![0].description)"
        print("response is \(response)")
        return response
    }
}
