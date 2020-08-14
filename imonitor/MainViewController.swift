//
//  MainViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/07/31.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit
import Foundation

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
        
        header.addSubview(imgStudent)

        nameLabel.text = "허예은"
        nameLabel.textColor = UIColor.white
        header.addSubview(nameLabel)
            
        collegeNameLabel.text = "IT대학"
        collegeNameLabel.textColor = UIColor.white
        header.addSubview(collegeNameLabel)
            
        deptNameLabel.text = "소프트웨어학부"
        deptNameLabel.textColor = UIColor.white
        header.addSubview(deptNameLabel)
        
        tableView.tableHeaderView = header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showDetail"{
               let vc = segue.destination as? DetailViewController
               if let index = sender as? Int{
                   let courseInfo = viewModel.courseInfo(at: index)
                   vc?.viewModel.update(model: courseInfo)
               }
           }
       }
       
    @IBAction func logoutButtonPressed(){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "search", sender: nil)
    }
}


extension MainViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        performSegue(withIdentifier: "showDetail", sender: indexPath.row)
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
        return viewModel.numofCourseInfo
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListCell else {
            return UITableViewCell()
        }
        
        let courseInfo = viewModel.courseInfo(at: indexPath.row)
        cell.update(info: courseInfo)
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
    let courseCode: String
    let startTime: String
    let endTime: String
    let notice: String
    
    init(course: String, professor: String, courseCode: String, startTime: String, endTime: String, notice: String){
        self.course = course
        self.professor = professor
        self.courseCode = courseCode
        self.startTime = startTime
        self.endTime = endTime
        self.notice = notice
    }
}

class CourseViewModel{
    let courseInfoList:[CourseInfo] = [
        CourseInfo(course:"데이터베이스응용", professor: "이상호", courseCode: "2050301", startTime:"2020.08.07 15:00:00", endTime: "2020.08.07 16:00:00", notice: "본 시험은 시험 기간 이후 접속할 시 접속할 수 없습니다. 그러니 주의하시고 시험 시간 몇 분전에 미리 접속하여 시험을 볼 수 있는 환경을 만들어 놓으시길 바랍니다."),
        CourseInfo(course:"운영체제", professor: "양승민", courseCode: "3020594", startTime:"2020.08.09 15:00:00", endTime: "2020.08.09 16:00:00", notice: "본 시험은 시험 기간 이후 접속할 시 접속할 수 없습니다. 그러니 주의하시고 시험 시간 몇 분전에 미리 접속하여 시험을 볼 수 있는 환경을 만들어 놓으시길 바랍니다."),
        CourseInfo(course:"시스템프로그래밍", professor: "최재영", courseCode: "342456", startTime:"2020.08.11 15:00:00", endTime: "2020.08.11 16:00:00", notice: "본 시험은 시험 기간 이후 접속할 시 접속할 수 없습니다. 그러니 주의하시고 시험 시간 몇 분전에 미리 접속하여 시험을 볼 수 있는 환경을 만들어 놓으시길 바랍니다.")
    ]
    
    var numofCourseInfo: Int{
        return courseInfoList.count
    }
    
    func courseInfo(at index: Int) -> CourseInfo{
        return courseInfoList[index]
    }
}

struct UserInfo{
    let id: String
    let name: String
    let major: String
}
