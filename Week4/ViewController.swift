//
//  ViewController.swift
//  Week4
//
//  Created by 권현석 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var movieTitle: String
    var release: String
}

class ViewController: UIViewController {

    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    @IBOutlet var movieTableView: UITableView!
    
    var movieList: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        movieTableView.dataSource = self
        movieTableView.delegate = self
        movieTableView.rowHeight = 60

        indicatorView.isHidden = true

    }
    
    func callRequest(date: String) {
        
        indicatorView.startAnimating()
        indicatorView.isHidden = false
     
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                print("JSON: \(json)")
                
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    
                    let movieNm = item["movieNm"].stringValue
                    let release = item["openDt"].stringValue
                    let data = Movie(movieTitle: movieNm, release: release)
                    self.movieList.append(data)
                }
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true
                self.movieTableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        //날짜 형식에 맞춰야함. 가령, 8글자 그리고 존재하는 날짜, 오늘 하루 전까지의 날짜까지만 동작하도록
        
        callRequest(date: searchBar.text!)
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
        cell.textLabel?.text = movieList[indexPath.row].movieTitle
        cell.detailTextLabel?.text = movieList[indexPath.row].release
        
        return cell
    }
}
