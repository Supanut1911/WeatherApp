//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Supanut Laddayam on 20/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    var name: String
    var main: Main
    var weather: [Weather]
    
    var model: WeatherModel {
        return WeatherModel(countryName: name,
                            temp: main.temp.toInt(),
                            conditionDescription: weather.first?.description ?? "",
                            conditionId: weather.first?.id ?? 0)
    }
}

struct Main: Codable {
    var temp: Double
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
}

struct WeatherModel {
    let countryName: String
    let temp: Int
    let conditionDescription: String
    let conditionId: Int
    
    var conditionImage: String {
        switch conditionId {
        case 200...299:
            return "imThunderstorm"
        case 300...399:
            return "imDrizzle"
        case 500...599:
            return "imRain"
        case 600...699:
            return "imSnow"
        case 700...799:
            return "imAtmosphere"
        case 800:
            return "imClear"
        default:
            return "imClouds"
        }
    }
}
