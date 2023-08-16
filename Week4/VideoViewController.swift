//
//  VideoViewController.swift
//  Week4
//
//  Created by 권현석 on 2023/08/08.
//

import UIKit

import SwiftyJSON
import Alamofire
import Kingfisher

struct Video {
    let author: String
    let date: String
    let runtime: Int
    let thumbnail: String
    let title: String
    let link: String
    
    var contents: String {
        return "\(author) | \(runtime)분 \n\(date)"
    }
}

class VideoViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var videoTableView: UITableView!
    
    var videoList: [Video] = []
    var codableVideoList: [Document] = []
    var page = 1
    var isEnd = false // 현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.prefetchDataSource = self
        videoTableView.rowHeight = 140
        
        searchBar.delegate = self
    }
    
    func callRequest(query: String, page: Int) {
        
        KakaoAPIManager.shared.codableRequest(type: .video, query: query) { video in
            self.codableVideoList = video.documents
            self.videoTableView.reloadData()
            
        }
        
    }
    
}

extension VideoViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        page = 1 //새로운 검색어이기 때문에 page를 1로 변경
        //        codableVideoList.removeAll()
        
        guard let query = searchBar.text else { return }
        callRequest(query: query, page: page)
    }
    
}

//UITableViewDataSourcePrefetching: iOS10 이상 사용 가능한 프로토콜, cellForRowAt 메서드가 호출되기 전에 미리 호출됨.
extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return codableVideoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = codableVideoList[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableViewCell") as? VideoTableViewCell else {
            
            return UITableViewCell() }
        
        cell.titleLabel.text = item.title
        cell.runtimeLabel.text = "\(item.playTime)분"
        if let url = URL(string: item.thumbnail) {
            cell.thumbnail.kf.setImage(with: url)
        }
        
        
        return cell
    }
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    //videoList 갯수와 indexPath.row 위치를 비교해 마지막 스크롤 시점을 확인 -> 네트워크 요청 시도
    //page count
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if codableVideoList.count - 1 == indexPath.row && page < 15 && !isEnd {
                page += 1
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
    
    
    //취소 기능: 직접 취소하는 기능을 구현해줘야함.
    //가령 스크롤를 빠르게 올릴 때 빠르게 지나간 데이터를 다 받아주면 모바일 디바이스에서 데이터를 너무 많이 사용할거임 그래서 빠르게 지나가는 데이터의 경우에는 아래의 메서드를 통해 데이터를 가져오는걸 취소할 수 있음.
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print("=====취소: \(indexPaths)")
    }
    
}

