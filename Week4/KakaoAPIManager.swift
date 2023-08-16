//
//  KakaoAPIManager.swift
//  Week4
//
//  Created by 권현석 on 2023/08/11.
//

import Foundation
import SwiftyJSON
import Alamofire

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    let header: HTTPHeaders = ["Authorization": APIKey.kakaoKey]
    
    private init() { }
    
    func codableRequest(type: EndPoint, query: String, completionHandler: @escaping (VideoModel)-> () ) {
        
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = type.url + text
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: VideoModel.self) { response in
                guard let video = response.value else { return }
                completionHandler(video)
            }
    }
}
