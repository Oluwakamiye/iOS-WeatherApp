//
//  WeatherResponse.swift
//  WeatherApp
//
//  Created by Oluwakamiye Akindele on 21/11/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import Foundation

struct WeatherResponse{
    var cityName : String = ""
    var country : String = ""
    var weatherType : String = ""
    var weatherConditionId : Int = 0
    var temperature : Float = 0.0
    var minTemperature : Float = 0.0
    var maxTemperature : Float = 0.0
    var humidity : Int = 0
    var wind : String = ""
    
    var temperatureString : String{
        return String(format: "%0.2f ℃",temperature)
    }
    
    var minTemperatureString : String{
        return String(format: "%0.2f ℃",minTemperature)
    }
    
    var maxTemperatureString : String{
        return String(format: "%0.2f ℃",maxTemperature)
    }
    
    var iconName : String{
        switch weatherConditionId{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
}
