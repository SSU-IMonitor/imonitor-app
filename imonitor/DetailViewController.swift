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
    
    let viewModel = DetailViewModel();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateUI(){
        if let courseInfo = viewModel.courseInfo{
            courseTitleLabel.text = courseInfo.course
            professorLabel.text = courseInfo.professor
        }
    }
}

class DetailViewModel{
    var courseInfo: CourseInfo?
    
    func update(model: CourseInfo?){
        courseInfo = model
    }
}