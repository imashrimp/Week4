//
//  DetectPapgoViewController.swift
//  Week4
//
//  Created by 권현석 on 2023/08/10.
//

import UIKit

import Alamofire
import SwiftyJSON

class DetectPapgoViewController: UIViewController {

    
    // 배열 아이템의 값을 한국어로 만들고 조건문이나 switch문 태워서 api 호출 시 들어가는 값을 영문으로 바꾸자
    let languageArray : [String] = ["한국어", "영어", "일본어", "중국어 간체", "중국어 번체", "베트남어", "인도네시아어", "태국어", "독일어", "러시아어", "스페인어", "이탈리아어", "프랑스어"]
    let languageCodeArray: [String] = ["ko", "en", "ja", "zh-CN", "zh-TW", "vi", "id", "th", "de", "ru", "es", "it", "fr"]
    
    var sourceLang = ""
    var targetLang = ""

    @IBOutlet var sourcePickerView: UIPickerView!
    @IBOutlet var sourceTextView: UITextView!
    @IBOutlet var translateButton: UIButton!
    @IBOutlet var targetPickerView: UIPickerView!
    @IBOutlet var targetTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sourcePickerView.delegate = self
        sourcePickerView.dataSource = self

        
        targetPickerView.delegate = self
        targetPickerView.dataSource = self
        
        targetTextView.isEditable = false
        
        sourcePickerView.tag = 0
        targetPickerView.tag = 1
        
        configure()
    }

    
    @IBAction func translateButtonTapped(_ sender: UIButton) {
        
        guard let typedText = sourceTextView.text else { return }
        
        changeToLangCode()
        
        callRequest(sourceLang: sourceLang, targetLang: targetLang, typedText: typedText)
        
    }
    
    func changeToLangCode() {
        
        for i in 0..<languageArray.count {
            if sourceLang == languageArray[i] {
                sourceLang = languageCodeArray[i]
            }
        }
        
        for i in 0..<languageArray.count {
            if targetLang == languageArray[i] {
                targetLang = languageCodeArray[i]
            }
        }
    }
    
    func callRequest(sourceLang: String, targetLang: String, typedText: String) {
        
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : APIKey.naverIDKey,
            "X-Naver-Client-Secret" : APIKey.naverSecret
        ]
        
        let parameter: Parameters = [
            "source" : sourceLang,
            "target" : targetLang,
            "text" : typedText
        ]
        
        AF.request(url, method: .post, parameters: parameter, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let translatedText = json["message"]["result"]["translatedText"].stringValue
                
                self.targetTextView.text = translatedText
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configure() {
        sourceTextView.text = ""
        sourceTextView.layer.borderWidth = 3
        
        targetTextView.text = ""
        targetTextView.layer.borderWidth = 3
        
        translateButton.setTitle("번역하기", for: .normal)
        translateButton.backgroundColor = .systemRed
        translateButton.setTitleColor(.white, for: .normal)
    }
}

extension DetectPapgoViewController: UIPickerViewDelegate {
    
    ///피커뷰 골랐을 때 나오는 값
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if pickerView.tag == 0 {
//
//        } else {
//
//        }
//    }
    
    //해당 휠에 나올 타이틀의 값?
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        //반환값을 sourceLang과 targetLang으로 해봐도 될 듯.
        if pickerView.tag == 0 {
            sourceLang = languageArray[row]
            return languageArray[row]
        } else {
            targetLang = languageArray[row]
            return languageArray[row]
        }
        
        if pickerView.tag == 0 {
            sourceLang = languageCodeArray[row]
            return sourceLang
        } else {
            targetLang = languageCodeArray[row]
            return targetLang
        }
        
    }
    
//    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
//        
//        // component는 휠이다. 휠 별 높이...? => 개당 높이 일까 아니면 휠 전체의 높이일까?
//        return
//    }
    
}

extension DetectPapgoViewController: UIPickerViewDataSource {
    
    ///피커뷰 휠 갯수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// 피커뷰 행 갯수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageArray.count
    }
    

    
    
}
