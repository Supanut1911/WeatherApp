//
//  ViewController.swift
//  WeatherApp
//
//  Created by Supanut Laddayam on 19/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import UIKit
import SkeletonView
import CoreLocation

protocol WeatherViewControllerDelegate: class {
    func didUpdateWeatherFromSearch(model: WeatherModel)
}

class WeatherVC: UIViewController {

    private let weatherManager = WeatherManager()
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        return manager
    } ()
    
    
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchWeather(byCity: "berlin")
    }
    
    private func fetchWeather(byLocation location: CLLocation) {
        showAnimation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeatherByCoordinate(lat: lat, lon: lon) { [weak self](result) in
            guard let this = self else {return}
            this.handleResult(result)
        }
    }
    
    private func fetchWeather(byCity city: String) {
        showAnimation()
        weatherManager.fetchWeather(byCity: city) { [weak self](result) in
        guard let this = self else {return}
        this.handleResult(result)
        }
    }
    
    private func handleResult(_ result: Result<WeatherModel, Error>) {
        switch result{
        case .success(let model):
            self.updateView(with: model)
            
        case .failure(let error):
            print(error)
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
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            promptForLocationPermission()
        }
    }
    
    private func promptForLocationPermission() {
        let alertController = UIAlertController(title: "Requires Location Permission", message: "Would you like to enable location permission in Settings?", preferredStyle: .alert)
        let enbleAction = UIAlertAction(title:"Go to Settings", style: .default) {      _ in
            guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {return}
            UIApplication.shared.open(settingURL, options: [:], completionHandler: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(enbleAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
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

extension WeatherVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations location:[CLLocation]) {
        if let location = location.last {
            manager.stopUpdatingLocation()
            fetchWeather(byLocation: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}
