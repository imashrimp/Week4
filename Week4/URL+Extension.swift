//
//  URL+Extension.swift
//  Week4
//
//  Created by 권현석 on 2023/08/11.
//

import Foundation

//애플에서 기본으로 제공해주는 구조체에 내가 원하는 함수를 추가할 수 있는거네

extension URL {
    
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndPointingString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
}
