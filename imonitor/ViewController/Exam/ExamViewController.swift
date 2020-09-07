//
//  ExamViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/07.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit
import SeeSo
import AVFoundation

let bounds: CGRect = UIScreen.main.bounds
let width = bounds.width
let height = bounds.height

var questionList = [QuestionInfo]()
var answerList = [String](repeating: " ", count: questionList.count)
var qnaIDList = [Int]()
var qnaAndAnswer = [SubmitParameter](repeating: SubmitParameter.init(qnaId: 0, answer: " "), count: questionList.count)

class ExamViewController: UIViewController {
    var tracker: GazeTracker? = nil
    var count: Int = 0
    var isWarning: Bool = false
    
    var courseName = ""
    var professorName = ""
    var end = ""
    var id = ""
    var accessToken: String = ""
    var cnt: Int = 1
    var numQuestion: Int = questionList.startIndex
    
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var answerTextField: UITextField!
    
    @IBOutlet var problemNumberLabel: UILabel!
    @IBOutlet var questionLabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getQuestions()
        answerTextField.addDoneButtonOnKeyboard()
        cameraPermissionCheck()
        updateUI()
    }
    
    func updateUI(){
        courseNameLabel.text = courseName
        professorLabel.text = professorName
        problemNumberLabel.text = "Problem \(cnt)"
        questionLabel.text = questionList[questionList.startIndex].question
        
         for i in 0..<qnaIDList.count{
            qnaAndAnswer[i].qnaId = qnaIDList[i]
        //            qnaAndAnswer[i].answer = answerList[i]
        }
    }
    
    func getQuestions(){
        guard let url = URL(string: "http://api.puroong.me/v1/exams/\(id)") else { return }
                    
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
                       
        let session = URLSession.shared
        session.dataTask(with: request){
            (data, response, error) in
                               
            if let data = data {
                do {
                    let myResponse = response as! HTTPURLResponse
                        print("Status Code:", myResponse.statusCode)
                                
                    if myResponse.statusCode == 200 {
                        let course = try JSONDecoder().decode(CourseExamInfo.self, from: data)
                        questionList = course.exam!.questions
                        
                        for question in questionList {
                            qnaIDList.append(question.id!)
                        }
                    } else if myResponse.statusCode == 403 {
                        print(myResponse.statusCode)
                        self.presentingViewController?.dismiss(animated: true, completion: nil)
                        self.alertNotAccepted()
                        
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
    
    func alertNotAccepted(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "경고", message: "승인이 되지 않은 시험입니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func cameraPermissionCheck(){
        if AVCaptureDevice .authorizationStatus(for: .video) == .authorized{
            GazeTracker.initGazeTracker(license: "dev_zjr3b5ffioy6jiynqtv99txxoi5dswqo6nukescw", delegate: self)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: {
                response in
                if response{
                    GazeTracker.initGazeTracker(license: "dev_zjr3b5ffioy6jiynqtv99txxoi5dswqo6nukescw", delegate: self)
                }
            })
        }
    }
    
    @IBAction func prevButtonPressed(_ sender: Any) {
        if answerTextField.text != "" {
            answerList[numQuestion] = answerTextField.text!
            qnaAndAnswer[numQuestion].answer = answerTextField.text!
        }
           
        print(answerList)
        numQuestion = numQuestion - 1

        if(numQuestion < 0){
            numQuestion = questionList.endIndex - 1
        }
        problemNumberLabel.text = "Problem \(numQuestion + 1)"
        questionLabel.text = questionList[numQuestion].question
        answerTextField.text = answerList[numQuestion]
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if answerTextField.text != "" {
            answerList[numQuestion] = answerTextField.text!
            qnaAndAnswer[numQuestion].answer = answerTextField.text!
        }
        numQuestion = numQuestion + 1

        if(numQuestion > questionList.endIndex - 1){
            numQuestion = 0
        }
        problemNumberLabel.text = "Problem \(numQuestion + 1)"
        questionLabel.text = questionList[numQuestion].question
        answerTextField.text = answerList[numQuestion]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if let view = segue.destination as? SubmitViewController{
            answerList[numQuestion] = answerTextField.text!
            view.answerList = answerList
            view.courseTitle = courseName
            view.professor = professorName
            view.qnaIdList = qnaIDList
            view.accessToken = accessToken
            view.examId = id
            print("prepare: \(qnaAndAnswer)")
            view.qnaAndAnswer = qnaAndAnswer
        }
    }
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "submitExam", sender: nil)
    }
    
//    func postSubmit(qnaAndAnswer: [SubmitParameter]){
//        let parameter = ["submits": qnaAndAnswer]
//
//        guard let url = URL(string: "http://api.puroong.me/v1/exams/\(id)/submit") else { return }
//        var request = URLRequest(url: url)
//
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
//
//        let httpBody = try! JSONEncoder().encode(parameter)
//
//        request.httpBody = httpBody;
//
//        let session = URLSession.shared
//        session.dataTask(with: request){
//            (data, response, error) in
//
//            if let data = data {
//                do {
//                    let myResponse = response as! HTTPURLResponse
//                        print("Status Code:", myResponse.statusCode)
//
//                    if myResponse.statusCode == 200 {
//                        let submit = try JSONDecoder().decode(SubmitInfo.self, from: data)
//                        print("result: \(submit.result)")
//                    } else if myResponse.statusCode == 404 || myResponse.statusCode == 500 {
//                        print(myResponse.statusCode)
//                    } else {
//                        let error = try JSONDecoder().decode(ErrorInfo.self, from: data)
//                        print(error.message)
//                    }
//                } catch {
//                    print("error: ", error)
//                }
//            }
//        }.resume()
//    }
}

// tracker 초기화
extension ExamViewController: InitializationDelegate{
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if(tracker != nil){
            self.tracker = tracker
            print("initialized Gaze Tracker")
            self.tracker?.statusDelegate = self
            self.tracker?.gazeDelegate = self
            self.tracker?.startTracking()
        } else {
            print("init failed: \(error.description)")
        }
    }
}

// tracker 시작 & 종료 console 띄우기
extension ExamViewController: StatusDelegate{
    func onStarted() {
        print("tracker starts tracking")
    }
    func onStopped(error: StatusError) {
        print("stop error: \(error.description)");
    }
}


extension ExamViewController: GazeDelegate{
    
    // 시선 인식
    func onGaze(timestamp: Double, x: Float, y: Float, state: TrackingState) {
//        print("timestamp: \(timestamp), (x, y): (\(x), \(y), state: \(state.description)")
        if x < 100.0 || y < 100.0 || x > Float(width) + 100.0 || y > Float(height) - 100.0 || x == Float(Double.nan) || y == Float(Double.nan)  {
            startCount()
        }
    }
    func onFilteredGaze(timestamp: Double, x: Float, y: Float, state: TrackingState) {
        
    }
    
    // 시선 이탈 횟수 카운트
    func startCount(){
        DispatchQueue.main.async {
            self.countLabel.text = "시선 이탈 횟수: \(self.count)번"
            self.count = self.count + 1
        }
        if self.count == 10 {
            alert()
        }
    }
    
    // 이탈 횟수 초과시 경고창
    func alert(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "경고", message: "경고 횟수 초과 시험 권한 박탈", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default){
                (action) in exit(0)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

