//
//  VideoModel.swift
//  Week4
//
//  Created by 권현석 on 2023/08/16.
//

import Foundation

// MARK: - Welcome
struct VideoModel: Codable {
    let documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let author: String
    let upLoadDate: String
    let playTime: Int
    let thumbnail: String
    let title: String

    enum CodingKeys: String, CodingKey {
        case author
        case upLoadDate = "datetime"
        case playTime = "play_time"
        case thumbnail, title
    }
}
