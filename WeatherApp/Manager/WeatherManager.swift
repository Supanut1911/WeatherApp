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
    case custom(description: String)
    
    var errorDescription: String? {
        switch self {
//        case .unknown:
//            return "Hey, this is an unknown error!"
        
        case .invalidCity:
            return "Hey, this is invalidCity, please try again!"
            
        case .custom(let description) :
            return description

        }
    }
}


struct WeatherManager {
    private let API_KEY = "3281d6d2d93e329f54948ee647965d9a"
        
    func fetchWeather(byCity city: String, completion:@escaping (Result<WeatherModel, Error>)-> Void) {
        
        let query = city.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? city
        
        let path = "http://api.openweathermap.org/data/2.5/weather?q=%@&appid=%@&units=metric"
        
        let urlString = String(format: path, city, API_KEY)
        
        handleRequest(urlString: urlString, completion: completion)
    }
    
        
    func fetchWeatherByCoordinate(lat :Double, lon: Double, completion:@escaping (Result<WeatherModel, Error>)-> Void) {
        
        let path = "https://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&appid=%@&units=metric?"
        
        let urlString = String(format: path , lat, lon ,API_KEY)
        print(urlString)
        handleRequest(urlString: urlString, completion: completion)
        
    }
    
    func handleRequest(urlString: String, completion:@escaping (Result<WeatherModel, Error>)-> Void) {
        AF.request(urlString)
            .validate()
            .responseDecodable(of: WeatherData.self, queue: .main, decoder: JSONDecoder()) { (res) in
            switch res.result {
            case .success(let weatherData):
                let model = weatherData.model
                completion(.success(model))
                
            case .failure(let error):

                
                if let err = self.getWeatherError(error: error, data: res.data) {
                    completion(.failure(err))
                } else {
                    completion(.failure(error))
                }

            }
        }
    }

    
    private func getWeatherError(error: AFError, data: Data?) -> Error? {
        if error.responseCode == 404, let data = data, let failure = try? JSONDecoder().decode(WeatherDataFailure.self, from: data) {
            let message = failure.message
            return WeatherError.custom(description: message)
        } else {
            return nil
        }
    }
    
}
