//
//  TranslateAPIManager.swift
//  Week4
//
//  Created by 권현석 on 2023/08/11.
//

import Foundation
import SwiftyJSON
import Alamofire


class TranslateAPIManager {
    
    static let shared = TranslateAPIManager()
    
    private init() { }
    
    func callRequest(text: String, resultString: @escaping (String) -> Void ) {
        
        let translationUrl = "https://openapi.naver.com/v1/papago/n2mt"
        
        let translationHeader: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverIDKey,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
        
        let translationParameters: Parameters = [
            "source" : "ko",
            "target" : "en",
            "text" : text
        ]

        AF.request(translationUrl, method: .post,parameters: translationParameters , headers: translationHeader).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let data = json["message"]["result"]["translatedText"].stringValue
                resultString(data)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
