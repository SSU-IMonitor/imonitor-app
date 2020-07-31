//
//  MainViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/07/31.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

/* MVVM

 Model
  - courseInfo
    > courseInfo 만들기
 
 View
  - ListCell
    > ListCell 필요한 정보를 ViewModel에서 받기
    > ListCell은 ViewModel로부터 받은 정보로 뷰 업데이트 하기
 
 View Model
  - courseViewModel
    > courseViewModel 만들기, 뷰 레이어에서 필요한 메소드 만들기
    > 모델 가지고 있기 courseInfo 등
 
 */

class MainViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let viewModel = CourseViewModel()
    
//    let courseList = ["데이터베이스 응용 [102000305]" , "운영체제 [30502031]", "시스템프로그래밍 [205039171]"]
//    let professorList = ["이상호", "양승민", "최재영"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150))
        
            
        let nameLabel = UILabel(frame: CGRect(x: 230, y: -30, width:150, height:150))
        let collegeNameLabel = UILabel(frame: CGRect(x: 230, y: 0, width:150, height:150))
        let deptNameLabel = UILabel(frame: CGRect(x: 230, y: 30, width:150, height:150))
        let image = UIImage(named: "person.jpg")
        
        var imgStudent: UIImageView!
        
            
        tableView.delegate = self
        tableView.dataSource = self
        
        header.backgroundColor =  UIColor(red: 93/255, green: 155/255, blue: 197/255, alpha: 1)
        
        
        imgStudent = UIImageView(frame: CGRect(x: 75, y: 35, width:75, height: 75))
        imgStudent.image = image
        imgStudent.layer.cornerRadius = 20.0
        imgStudent.layer.masksToBounds = true
        //imgStudent.layer.position =  CGPoint(x:self.view.bounds.width/10, y: self.view.bounds.height/10)
        
        header.addSubview(imgStudent)

        nameLabel.text = "허예은"
        nameLabel.textColor = UIColor.white
        //nameLabel.textAlignment = .center
        header.addSubview(nameLabel)
            
        collegeNameLabel.text = "IT대학"
        //deptNameLabel.textAlignment = .center
        collegeNameLabel.textColor = UIColor.white
        header.addSubview(collegeNameLabel)
            
        deptNameLabel.text = "소프트웨어학부"
        //deptNameLabel.textAlignment = .center
        deptNameLabel.textColor = UIColor.white
        header.addSubview(deptNameLabel)
        
        tableView.tableHeaderView = header
    }
    
    @IBAction func logoutButtonPressed(){
        dismiss(animated: true, completion: nil)
    }

}

extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
          tableView.deselectRow(at: indexPath, animated: true)
      }
}

extension MainViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 20.0
       }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return courseList.count
        return viewModel.numofCourseInfo
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        return cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let courseInfo = viewModel.courseInfo(at: indexPath.row)
        cell.update(info: courseInfo)
        
//        cell.courseTitleLabel.text = courseList[indexPath.row]
//        cell.professorLabel.text = professorList[indexPath.row]
        return cell
    }
}

class ListCell: UITableViewCell{
    @IBOutlet weak var courseTitleLabel: UILabel!
    @IBOutlet weak var professorLabel: UILabel!
    
    func update(info: CourseInfo){
        courseTitleLabel.text = info.course
        professorLabel.text = info.professor
    }
}

struct CourseInfo{
    let course: String
    let professor: String
    
    init(course: String, professor: String){
        self.course = course
        self.professor = professor
    }
}

class CourseViewModel{
    let courseInfoList:[CourseInfo] = [
        CourseInfo(course:"데이터베이스 응용 [102000305]", professor: "이상호"),
        CourseInfo(course:"운영체제 [30502031]", professor: "양승민"),
        CourseInfo(course:"시스템 프로그래밍 [205039171]", professor: "최재영")
    ]
    
    var numofCourseInfo: Int{
        return courseInfoList.count
    }
    
    func courseInfo(at index: Int) -> CourseInfo{
        return courseInfoList[index]
    }
}
