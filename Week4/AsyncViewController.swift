//
//  AsyncViewController.swift
//  Week4
//
//  Created by 권현석 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {
    
    @IBOutlet var firstImage: UIImageView!
    
    @IBOutlet var secondImage: UIImageView!
    
    @IBOutlet var thirdImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstImage.backgroundColor = .black
        print("1")
        
//        DispatchQueue.main.async{} => 중괄호 안에 있는걸 대기열에 넣고 한 스레드에 다 준 다음 그 스레드는 작업이 들어온 순서대로 일을 한다...? 아니면 한 스레드에 다 준 다음 메인스레드는 다른일을 땡겨와서 한다 인가?
        
    
        // 닭한테 '나중에 일해달라' 라고 지시하는 코드임. // 원래는 자세한 지시가 없으면 닭벼슬 혼자 다 처리했음(?) => 이거는 다시 물어보자
        DispatchQueue.main.async {
            print("2")
            
            // 스토리보드 디자인 -> viewDidLoad -> 사용자 눈에 보이는 디스플레이 순서로 실행되기 때문에 화면 비율로 디자인을 할 경우 사용자 눈에 보이는 ui의 모양과 개발자가 보는 스토리보드의 ui 모양이 다를 수 있음.
            self.firstImage.layer.cornerRadius = self.firstImage.frame.width / 2
        }
        
        print("3")
        
    }
    
    //sync async serial concurrent
    //UI Freezing
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg")!
        
        DispatchQueue.global().async {
            let data = try! Data(contentsOf: url)
            
            DispatchQueue.main.async {
                self.firstImage.image = UIImage(data: data)
            }
        }
    }
}
