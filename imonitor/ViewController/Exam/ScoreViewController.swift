//
//  ScoreViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/03.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var correct: Int = 0
    var courseTitle: String = " "
    var professor: String = " "
    var accessToken: String = " "
    var userId: String = " "
    var examId: String = " "
    var answerList = [String]()
    var scoreList = [AnswerInfo]()
    var isSubmitted: Bool = true
    
    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    
    @IBOutlet var correctLabel: UILabel!
    @IBOutlet var totalLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScore()
        
    }
    
    func getScore(){
        let url = URL(string: "http://api.puroong.me/v1/users/\(userId)/exams/\(examId)/submit")
        
        guard let requestURL = url else { fatalError() }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        
        let session = URLSession.shared
        session.dataTask(with: request) {
            (data, response, error) in
            
            if let data = data {
                do {
                    let myResponse = response as! HTTPURLResponse
                                
                    if myResponse.statusCode == 200 {
                        let answer = try JSONDecoder().decode(ScoreInfo.self, from: data)
                        self.scoreList = answer.result!
                        self.countCorrect()
                        self.updateUI()
                        // self.printAnswer(answer: self.scoreList)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func countCorrect(){
        for i in 0..<scoreList.count{
            if scoreList[i].isCorrect == true {
                correct+=1
            }
        }
    }
    
    func updateUI(){
        DispatchQueue.main.async {
            self.courseTitleLabel.text = self.courseTitle
            self.professorLabel.text = self.professor
            self.correctLabel.text = String(self.correct)
            self.totalLabel.text = String(self.scoreList.count)
            self.setTableView()
            self.tableView.reloadData()
        }
    }
    
//    func printAnswer(answer: [AnswerInfo]){
//        for i in 0..<scoreList.count{
//            print(answer[i].qna!.id as Any)
//            print(answer[i].qna!.answer as Any)
//        }
//    }
    
    func setTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("tableViewCellNum: \(scoreList.count)")
        return scoreList.count
    }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "answer")
            cell.textLabel?.text = "Problem \(indexPath.row + 1)"
            cell.detailTextLabel?.text = scoreList[indexPath.row].submittedAnswer
        
            if scoreList[indexPath.row].isCorrect == false{
                cell.detailTextLabel?.textColor = UIColor.red
            } else {
                cell.detailTextLabel?.textColor = UIColor(red: 93/255, green: 155/255, blue: 197/255, alpha: 1)
            }
            return cell
       }
    
    @IBAction func ExitButtonPressed(_ sender: Any) {
        alertExitExam()
    }

    func alertExitExam(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "현재 창을 닫겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default){
                    (action) in
                if(self.isSubmitted == false){
                    self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                } else {
                    self.presentingViewController?.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
                   
            self.present(alert, animated: true, completion: nil)
        }
    }
}
