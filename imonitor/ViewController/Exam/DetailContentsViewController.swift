//
//  DetailContentsViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/10.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class DetailContentsViewController: UIViewController {
//    let viewModel = DetailContentViewModel()
    
    @IBOutlet var courseIDLabel: UILabel!
    @IBOutlet var courseNameLabel: UILabel!
    @IBOutlet var startTimeLabel: UILabel!
    @IBOutlet var endTimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        updateUI()
    }
    
//    func updateUI(){
//        if let courseInfo = viewModel.courseInfo{
//            print(courseInfo.courseCode)
//            courseIDLabel.text = courseInfo.courseCode
//            courseNameLabel.text = courseInfo.course
//            startTimeLabel.text = courseInfo.startTime
//            endTimeLabel.text = courseInfo.endTime
//        }
//    }
}

//class DetailContentViewModel{
//    var courseInfo: CourseInfo?
//    
//    func update(model: CourseInfo?){
//        courseInfo = model
//    }
//}

