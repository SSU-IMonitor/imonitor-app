//
//  ScoreViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/03.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var answerList = [String]()
    var courseTitle: String = " "
    var professor: String = " "
    
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        getScore()
    }
    
    func updateUI(){
        courseTitleLabel.text = courseTitle
        professorLabel.text = professor
    }
    
    func getScore(){
        
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
    
    @IBAction func ExitButtonPressed(_ sender: Any) {
        alertExitExam()
    }
    
    func alertExitExam(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "현재 창을 닫겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel){
                       (action) in
                self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
                   
            self.present(alert, animated: true, completion: nil)
        }
    }
}
