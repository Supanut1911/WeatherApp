//
//  DoubleExtenstion.swift
//  WeatherApp
//
//  Created by Supanut Laddayam on 20/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import Foundation

extension Double {
    func toString() -> String{
        return String(format: "%.1f",self)
    }
    
    func toInt() -> Int{
        return Int(self)
    }
}
