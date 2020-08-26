//
//  DetailTableViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/09.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
//    let viewModel = DetailTableViewModel()

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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
//    class DetailTableViewModel{
//        var courseInfo: CourseInfo?
//        
//        func update(model: CourseInfo?){
//            courseInfo = model
//        }
//    }
}
