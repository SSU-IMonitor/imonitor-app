//
//  SubmitViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/01.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class SubmitViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var accessToken: String = " "
    var courseTitle: String = " "
    var professor: String = " "
    var examId: String = ""
    var userId: String = ""
    var answerList = [String](repeating: "", count: questionList.count)
    var qnaIdList = [Int]()
    var qnaAndAnswer = [SubmitParameter]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Submit examId: \(examId)")
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
            let okAction = UIAlertAction(title: "확인", style: .default){
                (action) in
                self.postSubmit(qnaAndAnswer: self.qnaAndAnswer)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func postSubmit(qnaAndAnswer: [SubmitParameter]){
        print(qnaAndAnswer)
        let parameter = ["submits": qnaAndAnswer]
        
        guard let url = URL(string: "http://api.puroong.me/v1/exams/\(examId)/submit") else { return }
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")

        let httpBody = try! JSONEncoder().encode(parameter)
        
        request.httpBody = httpBody;
               
        let session = URLSession.shared
        session.dataTask(with: request){
            (data, response, error) in
                       
            if let data = data {
                do {
                    let myResponse = response as! HTTPURLResponse
                        print("Status Code:", myResponse.statusCode)
                           
                    if myResponse.statusCode == 200 {
                        DispatchQueue.main.async{
                            let vc = self.storyboard?.instantiateViewController(identifier: "score") as! ScoreViewController
                                vc.modalPresentationStyle = .fullScreen
                            vc.answerList = self.answerList
                            vc.courseTitle = self.courseTitle
                            vc.professor = self.professor
                            vc.accessToken = self.accessToken
                            vc.userId = self.userId
                            vc.examId = self.examId
                            
                            self.present(vc, animated: true)
                        }
                    } else if myResponse.statusCode == 404 || myResponse.statusCode == 500 {
                        print(myResponse.statusCode)
                    } else {
                        let error = try JSONDecoder().decode(ErrorInfo.self, from: data)
                        print(error.message)
                    }
                } catch {
                    print("error: ", error)
                }
            }
        }.resume()
    }
}
