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

class ExamViewController: UIViewController {
    var tracker: GazeTracker? = nil
    var count: Int = 0
    var isWarning: Bool = false
    
    var courseName = ""
    var professorName = ""
    var end = ""
    var id = ""
    var accessToken: String = ""
    
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var answerTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        getQuestions()
        answerTextField.addDoneButtonOnKeyboard()
        cameraPermissionCheck()
    }
    
    func updateUI(){
        courseNameLabel.text = courseName
        professorLabel.text = professorName
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
                        let courses = try JSONDecoder().decode(CourseExamInfo.self, from: data)
                        print(courses)
                    
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
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "submitExam", sender: nil)
//        let vc = storyboard?.instantiateViewController(identifier: "submit") as! SubmitViewController
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)
    }
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

