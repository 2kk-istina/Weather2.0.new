//
//  ViewController.swift
//  Weather2.0.
//
//  Created by Истина on 21/05/2019.
//  Copyright © 2019 Истина. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var conditionLabel: UILabel!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var backgroundView: UIView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude

        let weatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather?lat="
        let weatherAPI = "2511df014914446d7acfae5811bb0934"
        
        guard let url = URL(string: "\(weatherMapBaseURL)\(lat)&lon=\(lon)&appid=\(weatherAPI)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                let jsonData = try
                    JSONDecoder().decode(CurrentLocalWeather.self, from: data)
                DispatchQueue.main.async {
                    let jsonCity = jsonData.name
                    let jsonTemp = jsonData.main.temp - 273.15
                    self.locationLabel.text = jsonCity
                    self.temperatureLabel.text = String(Int(round(jsonTemp)))
                    
                    let jsonWeatherArray = jsonData.weather
                    for x in jsonWeatherArray {
                        self.conditionImageView.image = UIImage(named: x.icon)
                        self.conditionLabel.text = x.description
                    }
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    dateFormatter.dateFormat = "MMM d, yyyy"
                    dateFormatter.locale = Locale(identifier: "en_US")
                    self.dayLabel.text = dateFormatter.string(from: date)
                    
                    
                }
            } catch let jsonError {
                print("Error serializing:", jsonError)
            }
            }.resume()
    }
    
    
}




