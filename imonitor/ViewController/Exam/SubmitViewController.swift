//
//  SubmitViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/01.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var answerList = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell.textLabel?.text = "Problem \(indexPath.row + 1)"
            cell.detailTextLabel?.text = answerList[indexPath.row]
            return cell
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        alertSubmit()
    }
    
    func alertSubmit(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "시험지를 제출하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel){
                (action) in
                let vc = self.storyboard?.instantiateViewController(identifier: "score") as! ScoreViewController
                    vc.modalPresentationStyle = .fullScreen
                vc.answerList = self.answerList
                self.present(vc, animated: true)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
}
