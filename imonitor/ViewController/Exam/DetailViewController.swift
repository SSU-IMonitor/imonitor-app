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
    
    let viewModel = DetailViewModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func startPressed(_ sender: Any) {
        let course = courseTitleLabel.text
        let professor = professorLabel.text
        let endTime = endTimeLabel.text
        
        let vc = storyboard?.instantiateViewController(identifier: "exam") as! ExamViewController
        
        vc.courseName = course!
        vc.professorName = professor!
        vc.end = endTime!
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
        
        
        
    }
    
    func updateUI(){
        if let courseInfo = viewModel.courseInfo{
            courseTitleLabel.text = courseInfo.course
            professorLabel.text = courseInfo.professor
            noticeLabel.text = courseInfo.notice
            courseIDLabel.text = courseInfo.courseCode
            courseTitle2Label.text = courseInfo.course
            startTimeLabel.text = courseInfo.startTime
            endTimeLabel.text = courseInfo.endTime
        }
    }
}

class DetailViewModel{
    var courseInfo: CourseInfo?
    
    func update(model: CourseInfo?){
        courseInfo = model
    }
}