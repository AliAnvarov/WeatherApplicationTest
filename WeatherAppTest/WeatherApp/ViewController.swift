import UIKit
import CoreLocation
import Alomofire
import SwiftyJSON

class ViewController: UIViewController,CLLocationManagerDelegate, ChangeCityDelegate {
    
    let API_KEY = "1bb48dd8dd97c0565fc6306795b50ac4"
    let WEATHER_URL = "https://api.openweathermap.org/data/2.5/weather"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        cityLabel.text = "Loading..."
        temperatureLabel.text = ""
        weatherIcon.isHidden = true
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
     
    func getWeatherData(url: String, parameters: [String : String]){
        Alamofire.request(url,method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess && JSON(response.result.value!)["cod"].stringValue == "200"{
                let weatherData : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherData)
            }else{
                if let errorValue = response.result.error{
                    print("Error : \(errorValue)")
                    self.cityLabel.text = "Connection failed"
                }else if JSON(response.result.value!)["cod"].stringValue != "200" {
                    print("Error : \( JSON(response.result.value!)["message"].stringValue)")
                    self.cityLabel.text = "Weather data unavailable"
                }
            }
        }
    }
     
    
    func updateWeatherData(json : JSON){
        
        weatherDataModel.temp = Int(json["main"]["temp"].double! - 273.15)
        weatherDataModel.city = json["name"].stringValue
        weatherDataModel.condition = json["weather"][0]["id"].intValue
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
        print(weatherDataModel.weatherIconName)
        print(weatherDataModel.condition)
        
        updateUIWithWeatherData()
        
        
    }
     
     
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temp)℃"
        weatherIcon.image = UIImage(named: "\(weatherDataModel.weatherIconName)")
        weatherIcon.isHidden = false
        
    }
     
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0{
            locationManager.stopUpdatingLocation()
            
            print("Longitude : \(location.coordinate.longitude) & Latitude :  \(location.coordinate.latitude) & altitude : \(location.altitude)")
            
            let params : [String : String] = ["lat" : "\(location.coordinate.latitude)", "lon" : "\(location.coordinate.longitude)", "appid" : API_KEY]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
     
     
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
     
    
    func showAlertDialog(message: String, title: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Restart the Game", style: .default, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert,animated: true, completion: nil)
    }
     
     
    func userEnteredNewCityName(city: String?){
        if city != nil {
            let params : [String: String] = ["q" : city!, "appid" : API_KEY]
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseCity"{
            let destVC = segue.destination as! SecondViewController
            destVC.delegate = self
        }
    }


}

