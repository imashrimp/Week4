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

        callRequest()
    }
    
    func callRequest() {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&appid=\(APIKey.openWeatherKey)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let temp = json["main"]["temp"].doubleValue - 273.15
                let humidity = json["main"]["humidity"].intValue
                
                let id = json["weather"][0]["id"].intValue // 803
                
                switch id {
                case 800:
                    print("매우 맑음")
                case 801...899:
                    self.view.backgroundColor = .systemBlue
                    print("구름이 낌")
                default:
                    print("날씨 모름")
                }
                
                self.weatherLabel.text = "\(id)"
                self.tempLabel.text = "온도: 섭씨 \(temp)도"
                self.humidityLabel.text = "습도: \(humidity)%"
                
            case .failure(let error):
                print(error)
            }
        }
        
    }

}
