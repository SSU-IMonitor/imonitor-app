//
//  SubmitViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/01.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController {
    
    var answerList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        alertSubmit()
    }
    
    func alertSubmit(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "시험지를 제출하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel)
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
