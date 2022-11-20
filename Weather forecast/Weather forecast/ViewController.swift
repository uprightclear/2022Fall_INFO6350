//
//  ViewController.swift
//  Weather forecast
//
//  Created by uprightclear on 11/19/22.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON
import SwiftSpinner


class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var txtPlace: UITextField!
    
    @IBOutlet weak var tblView: UITableView!
    let locationManager = CLLocationManager()
    var lat: CLLocationDegrees?
    var lng: CLLocationDegrees?
    var address = ""
    
    var temps: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        lat = location.coordinate.latitude
        lng = location.coordinate.longitude
        
        print(lat ?? 0)
        print(lng ?? 0)
        
        getAddressFromLocation(location: location)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getAddressFromLocation( location: CLLocation){
        
        let clGeoCoder = CLGeocoder()
        
        clGeoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            guard let place = placeMarks?.first else { return }
            
//            if place.name != nil {
//                address += place.name! +  ", "
//            }
            
            if place.locality != nil {
                self.address += place.locality!
            }
//            if place.subLocality != nil {
//                address += place.subLocality! +  ", "
//            }
//
//            if place.postalCode != nil {
//                address += place.postalCode! +  ", "
//            }
//
//            if place.country != nil {
//                address += place.country!
//            }
            
            print(self.address)
            
        }
    }

    @IBAction func getCurrentWeatherAction(_ sender: Any) {
        let locationStr = "\(self.lat!),\(self.lng!)"
        var url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations="
        url += locationStr
        url += "&aggregateHours=24&unitGroup=us&shortColumnNames=false&contentType=json&key=AYQR6QM5KHFYVPH9M4EXXJUCC"
        
        AF.request(url).responseJSON { responseData in

            if responseData.error != nil {
                print(responseData.error!)
                return
            }

            let weatherData = JSON(responseData.data as Any)
            let forecastValues =  weatherData["locations"][locationStr]["values"]
            print(forecastValues.count)
            self.temps = [String]()
            for forecast in forecastValues {
                let forecastJSON = JSON(forecast.1)
                let temp = forecastJSON["temp"].floatValue
                let condition = forecastJSON["conditions"].stringValue
                let str = "Temperature = \(temp)°F, \(condition)"
                self.temps.append(str)
            }
            self.tblView.reloadData()
        }
    }
    
    @IBAction func getWeatherAction(_ sender: Any) {
        let locationStr = txtPlace.text
        var url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/weatherdata/forecast?locations="
        url += locationStr!
        url += "&aggregateHours=24&unitGroup=us&shortColumnNames=false&contentType=json&key=AYQR6QM5KHFYVPH9M4EXXJUCC"
        
        AF.request(url).responseJSON { responseData in

            if responseData.error != nil {
                print(responseData.error!)
                return
            }

            let weatherData = JSON(responseData.data as Any)
            let forecastValues =  weatherData["locations"][locationStr!]["values"]
            print(forecastValues.count)
            self.temps = [String]()
            for forecast in forecastValues {
                let forecastJSON = JSON(forecast.1)
                let temp = forecastJSON["temp"].floatValue
                let condition = forecastJSON["conditions"].stringValue
                let str = "Temperature = \(temp)°F, \(condition)"
                self.temps.append(str)
            }
            self.tblView.reloadData()
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return temps.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = temps[indexPath.row]

        return cell
    }
    

}

