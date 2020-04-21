//
//  AddCityVC.swift
//  WeatherApp
//
//  Created by Supanut Laddayam on 20/4/2563 BE.
//  Copyright © 2563 Supanut LDM. All rights reserved.
//

import Foundation
import UIKit



class AddCityVC: UIViewController {
    @IBOutlet weak var statusLable: UILabel!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    private let weatherManager = WeatherManager()
    weak var delegate: WeatherViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cityTextField.becomeFirstResponder()
    }
    
    private func setUpView() {
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.4)
        statusLable.isHidden = true
    }
    
    private func setUpGestures(){
        let tapGresture = UITapGestureRecognizer(target: self, action: #selector(dissmissVC))
        
        tapGresture.delegate = self
        view.addGestureRecognizer(tapGresture)
    }
    
    @objc func dissmissVC(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonTap(_ sender: UIButton) {
        statusLable.isHidden = true
        guard let query = cityTextField.text, !query.isEmpty else {
            showSearchError(text: "City cannot be empty , Please try again!")
            return }
        handleSearch(query: query)
    }
    
    private func showSearchError(text: String) {
        statusLable.isHidden = false
        statusLable.textColor = .systemRed
        statusLable.text = text
    }
    
    private func handleSearch(query: String) {
        view.endEditing(true)
        activityView.startAnimating()
        weatherManager.fetchWeather(byCity: query) { [weak self](result) in
            guard let this = self else {return}
            this.activityView.stopAnimating()
            switch result {
            case .success(let model):
                this.handleSearchSuccess(model: model)
            case .failure(let error) :
                this.showSearchError(text: error.localizedDescription)
            }
        }
    }
    
    private func handleSearchSuccess(model: WeatherModel) {
        statusLable.isHidden = false
        statusLable.textColor = .systemGreen
        statusLable.text = "Success!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let this = self else {return }
            this.delegate?.didUpdateWeatherFromSearch(model: model)
        }
        
        
    }
    
}

extension AddCityVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
    
    
}


