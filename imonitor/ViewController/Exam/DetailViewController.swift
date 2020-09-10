//
//  DetailViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/05.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class DetailViewController: UIViewController{

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
    
    var course: ExamInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        caculateRemainTime()
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
        
        var strRemainTime: String = ""
        
        strRemainTime = setRemainZero(day: day, hour: hour, minute: minute, second: second)
        remainTime.text = strRemainTime
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
    
    func parsingTime(time: String) -> String{
        let str = time
        let arr = str.components(separatedBy: ["-","T",":","."])
        let strDate = arr[0] + "-" + arr[1] + "-" + arr[2] + " " + arr[3] + ":" + arr[4] + ":" + arr[5]
        return strDate
    }
    
    func setRemainZero(day: Int, hour: Int, minute: Int, second: Int) -> String{
        var strRemainTime = "\(day)일 \(hour)시간 \(minute)분 \(second)초 남음"
        
        if day == 0 {
            strRemainTime = "\(hour)시간 \(minute)분 \(second)초 남음"
            if hour == 0 {
                strRemainTime = "\(minute)분 \(second)초 남음"
            }
            if minute == 0 {
                strRemainTime = "\(second)초 남음"
            }
        }
        
        if day != 0 && hour == 0 {
            strRemainTime = "\(day)일 \(minute)분 \(second)초 남음"
            
            if minute == 0 {
                strRemainTime = "\(day)일 \(second)초 남음"
            }
        }
        
        if day != 0 && hour != 0 && minute == 0 {
            strRemainTime = "\(day)일 \(hour)시간 \(second)초 남음"
        }
        
        if day != 0 && hour != 0 && minute != 0 && second == 0 {
            strRemainTime = "\(day)일 \(hour)시간 \(minute)분 남음"
        }
        
        return strRemainTime
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startPressed(_ sender: Any) {
        setLoading()
    }
    
    
    func setLoading(){
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballScaleMultiple, color: UIColor(red: 93/255, green: 155/255, blue: 197/255, alpha: 1), padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 60),
            loading.heightAnchor.constraint(equalToConstant: 60),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loading.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5){
            loading.stopAnimating()
            self.moveToExam()
        }
    }
    func moveToExam(){
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
}
