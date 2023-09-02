//
//  WeatherViewController.swift
//  Week4
//
//  Created by 권현석 on 2023/08/08.
//

import UIKit
import SwiftyJSON
import Alamofire

class WeatherViewController: UIViewController {
    
    @IBOutlet var weatherLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest { todayWeather in
            
            guard let weatherData = todayWeather else { return }
            
            self.weatherLabel.text = weatherData.weather[0].main
            self.tempLabel.text = "\(weatherData.main.temp)"
            self.humidityLabel.text = "\(weatherData.main.humidity)"
        }
    }
    
    func callRequest(completionHandler: @escaping (OpenWeather?) -> Void ) {
        
        let scheme = "https"
        let host = "api.openweathermap.org"
        let path = "/data/2.5/weather"
        
        let key = APIKey.openWeatherKey
        let latValue = "44.34"
        let lonValue = "10.99"
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "lat", value: latValue),
            URLQueryItem(name: "lon", value: lonValue),
            URLQueryItem(name: "appid", value: key)
        ]
        
        guard let openWeatherURL = components.url else { return }
        
        URLSession.shared.dataTask(with: openWeatherURL) { data, response, error in
            
            DispatchQueue.main.async {
                
                if let error {
                    completionHandler(nil)
                    print(error)
                }
                
                guard
                    let response = response as? HTTPURLResponse, (200...500).contains(response.statusCode) else
                {
                        completionHandler(nil)
                        print(error)
                        return
                    }
                
                guard
                    let data = data else {
                    completionHandler(nil)
                    print(error)
                    return
                }
                
                do {
                    let result = try? JSONDecoder().decode(OpenWeather.self, from: data)
                    completionHandler(result)
                } catch {
                    completionHandler(nil)
                    print(error.localizedDescription)
                }
            }
        }.resume()
        
        
//        AF.request(url, method: .get).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//
//                let temp = json["main"]["temp"].doubleValue - 273.15
//                let humidity = json["main"]["humidity"].intValue
//
//                let id = json["weather"][0]["id"].intValue // 803
//
//                switch id {
//                case 800:
//                    print("매우 맑음")
//                case 801...899:
//                    self.view.backgroundColor = .systemBlue
//                    print("구름이 낌")
//                default:
//                    print("날씨 모름")
//                }
//
//                self.weatherLabel.text = "\(id)"
//                self.tempLabel.text = "온도: 섭씨 \(temp)도"
//                self.humidityLabel.text = "습도: \(humidity)%"
//
//            case .failure(let error):
//                print(error)
//            }
//        }
        
    }
    
}
