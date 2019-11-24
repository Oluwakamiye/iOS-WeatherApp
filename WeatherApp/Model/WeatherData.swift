//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Oluwakamiye Akindele on 21/11/2019.
//  Copyright © 2019 Oluwakamiye Akindele. All rights reserved.
//

import Foundation

struct WeatherData : Decodable{
    var coord : Coordinate = Coordinate()
    var weather : [WeatherMeta]? = nil
    var base : String = ""
    var main : Main = Main()
    var visibility : Int = 0
    var dt : Int = 0
    var timezone : Int = 0
    var id : Int = 0
    var name : String = ""
    var cod : Int = 0
}

struct Coordinate : Decodable{
    var lon : Float = 0.0
    var lat : Float = 0.0
}

struct WeatherMeta : Decodable{
    var id : Int = 0
    var description : String = ""
    var main : String = ""
    var icon : String = ""
}

struct Main : Decodable{
    var temp : Float = 0.0
    var pressure : Int = 0
    var humidity : Int = 0
    var temp_min : Float = 0.0
    var temp_max : Float = 0.0
}
