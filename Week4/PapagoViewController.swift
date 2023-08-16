//
//  PapagoViewController.swift
//  Week4
//
//  Created by 권현석 on 2023/08/10.
//

import UIKit
import SwiftyJSON
import Alamofire

class PapagoViewController: UIViewController {

    @IBOutlet var origianlTextView: UITextView!
    
    @IBOutlet var requestButton: UIButton!
    
    @IBOutlet var translateTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //helper.nickname //이건 뭔가 기초를 열심히 닦아둔 느낌이다. 기초가 견고하니까 수행할 때 간략하게 할 수 있는 느낌.
        
//        UserDefaultHelper.standard.nickname //싱글톤 형태로 사용
//        UserDefaultHelper.standard.age

        origianlTextView.text = ""
        translateTextView.text = ""
        translateTextView.isEditable = false
        
    }
    
    func callLangRequest() {
        let langURL = "https://openapi.naver.com/v1/papago/detectLangs"
        let langHeaders: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverIDKey,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
        
        guard let typedText = origianlTextView.text else { return }
        let langParameter: Parameters = ["query" : typedText ]
        
        AF.request(langURL, method: .post, parameters: langParameter, headers: langHeaders).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let language = json["langCode"].stringValue
                print(language)
                
                self.callPapagoRequest(language: language)
                
                print("JSON: \(json)")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func callPapagoRequest(language: String) {
        let translationUrl = "https://openapi.naver.com/v1/papago/n2mt"
        
        let translationHeader: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverIDKey,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
        let translationParameters: Parameters = [
            "source" : language,
            "target" : "en",
            "text" : origianlTextView.text ?? ""
        ]

        AF.request(translationUrl, method: .post,parameters: translationParameters , headers: translationHeader).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")

                let data = json["message"]["result"]["translatedText"].stringValue

                self.translateTextView.text = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    @IBAction func requestButtonClicked(_ sender: UIButton) {
//        callLangRequest()
        
        TranslateAPIManager.shared.callRequest(text: origianlTextView.text) { result in
            self.translateTextView.text = result
        }
    }
    
}
