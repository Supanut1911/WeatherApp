//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Supanut Laddayam on 20/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import Foundation
import Alamofire

enum WeatherError: Error, LocalizedError {
//    case unknown
    case invalidCity
    
    var errorDescription: String? {
        switch self {
//        case .unknown:
//            return "Hey, this is an unknown error!"
        
        case .invalidCity:
            return "Hey, this is invalidCity, please try again!"
        }
    }
}


struct WeatherManager {
    private let API_KEY = "3281d6d2d93e329f54948ee647965d9a"
    
    func fetchWeather(byCity city: String, completion:@escaping (Result<WeatherModel, Error>)-> Void) {
        
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        
        let path = "http://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        
        let urlString = String(format: path, city, API_KEY)
        
        AF.request(urlString).responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (res) in
            switch res.result {
            case .success(let weatherData):
                let model = weatherData.model
                completion(.success(model))
                
            case .failure(let error):
              print(res.response?.statusCode)
                let statusCode = res.response?.statusCode
       
                if statusCode == 404 {
                    let invalidCityError = WeatherError.invalidCity
                    completion(.failure(invalidCityError))
                } else {
                    completion(.failure(error))
                }
                
                
                
                
            }
        }
    }
    
}
