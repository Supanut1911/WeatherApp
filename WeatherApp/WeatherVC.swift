//
//  ViewController.swift
//  WeatherApp
//
//  Created by Supanut Laddayam on 19/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import UIKit
import SkeletonView

protocol WeatherViewControllerDelegate: class {
    func didUpdateWeatherFromSearch(model: WeatherModel)
}

class WeatherVC: UIViewController {

    private let weatherManager = WeatherManager()
    
    var resData = [WeatherData]()
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        weatherManager.fetchWeather(byCity: "London")
        showAnimation()
        fetchWeather()
     
    }
    
    private func fetchWeather() {
        weatherManager.fetchWeather(byCity: "Thailand") { (result) in
            switch result{
            case .success(let model):
                self.updateView(with: model)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateView(with model: WeatherModel) {
        hindAnimate()
        
        self.tempLabel.text = model.temp.toString().appending("C")
        self.conditionLabel.text = model.conditionDescription
        navigationItem.title = model.countryName
        conditionImageView.image = UIImage(named: model.conditionImage)
        
        
    }
    
    private func hindAnimate() {
        conditionImageView.hideSkeleton()
        tempLabel.hideSkeleton()
        conditionLabel.hideSkeleton()
    }
    
    
    private func showAnimation() {
        conditionImageView.showAnimatedGradientSkeleton()
        tempLabel.showAnimatedGradientSkeleton()
        conditionLabel.showAnimatedGradientSkeleton()
    }

    @IBAction func addLocationPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showAddCity", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAddCity" {
            if let destination = segue.destination as? AddCityVC {
                destination.delegate = self
            }
        }
    }
    
    @IBAction func currentLocationPress(_ sender: Any) {
    }
    

}

extension WeatherVC: WeatherViewControllerDelegate {
    func didUpdateWeatherFromSearch(model: WeatherModel) {
        presentedViewController?.dismiss(animated: true, completion: { [weak self] in
            guard let this = self else {return}
            this.updateView(with: model)
        })
        
       
        
        
    }
    
    
}

