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

        //MARK: - error handling 해보기
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of: VideoModel.self) { response in
                guard let video = response.value else { return }
                completionHandler(video)
            }
    }
    
    func handleStatusCode(statusCode: Int) throws {
        guard statusCode == 400 else {
            print("일단 성공 빼고 다 에러 때려")
            throw KakaoVideoError.general
        }
    }
}
