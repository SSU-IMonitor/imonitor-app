//
//  DetailViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/05.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    // MVVM
    
    // Model
    // - courseInfo
    // > courseInfo 만들기
    
    // View
    // - courseTitleLabel, professorLabel
    // > view들은 viewModel을 통해서 구현
    
    // View Model
    // - Detail View Model
    // > 뷰 레이어에 피료한 메소드 만들기
    // > 모델 가지고 있기 (courseInfo)
    

    @IBOutlet var courseTitleLabel: UILabel!
    @IBOutlet var professorLabel: UILabel!
    @IBOutlet var noticeLabel: UITextView!

    @IBOutlet var courseIDLabel: UILabel!
    @IBOutlet var courseTitle2Label: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    @IBOutlet var remainTime: UILabel!
    
    var accessToken: String = ""
    var userId: String = ""
    
    //    var course: ExamInfo!
    var course: ExamInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        caculateRemainTime()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startPressed(_ sender: Any) {
        let course = courseTitleLabel.text
        let professor = professorLabel.text
        let endTime = endTimeLabel.text
        let id = courseIDLabel.text
        
        let vc = storyboard?.instantiateViewController(identifier: "exam") as! ExamViewController
        
        vc.courseName = course!
        vc.professorName = professor!
        vc.end = endTime!
        vc.examId = String(id!)
        vc.userId = userId
        vc.accessToken = accessToken
        
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func updateUI(){
        courseTitleLabel.text = course.title
        professorLabel.text = course.owner?.name
        noticeLabel.text = course.notice
        courseIDLabel.text = "\(course.id!)"
        courseTitle2Label.text = course.courseName
        startTimeLabel.text = parsingTime(time: course.startTime!)
        endTimeLabel.text = parsingTime(time:course.endTime!)
    }
    
    func parsingTime(time: String) -> String{
        let str = time
        let arr = str.components(separatedBy: ["-","T",":","."])
        let strDate = arr[0] + "-" + arr[1] + "-" + arr[2] + " " + arr[3] + ":" + arr[4] + ":" + arr[5]
        return strDate
    }

    func changeStringToDate(time: String) -> Date{
        let parsingDate = parsingTime(time: time)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let date = formatter.date(from: parsingDate)
        let realDate = date! + 32400
        
        return realDate
    }
    
    func caculateRemainTime(){
        let now = NSDate()
        print("now: \(now)")
        let startTime = changeStringToDate(time: course.startTime!)
        print(startTime)
        
        let timeInterval = Int(startTime.timeIntervalSince(now as Date))
        print("Time Interval: \(timeInterval)")
        
        let day = timeInterval / 86400
        let remainDay = timeInterval % 86400
        
        let hour = remainDay / 3600
        let remainHour = remainDay % 3600
        
        let minute = remainHour / 60
        
        let second = remainHour % 60
        
        let strRemainTime = "\(day)일 \(hour)시간 \(minute)분 \(second)초 남음"
        
        remainTime.text = strRemainTime
    }
    
    func caculateCurrentTime()-> String{
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: now as Date)
    }
}
