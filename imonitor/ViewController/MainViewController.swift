//
//  MainViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/07/31.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit
import Foundation

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    
    var idText: String = ""
    var majorText: String = ""
    var nameText: String = ""
    var accessToken: String = ""
    var rowSelected: Int = 0
    
    var myCourses = [ExamInfo]()
    
    let nameLabel = UILabel(frame: CGRect(x: 230, y: -30, width:150, height:150))
    let collegeNameLabel = UILabel(frame: CGRect(x: 230, y: 0, width:150, height:150))
    let deptNameLabel = UILabel(frame: CGRect(x: 230, y: 30, width:150, height:150))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postMyCourses{
            self.tableView.reloadData()
        }
        
        setUptableView()
        
        let image = UIImage(named: "person.jpg")
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 150))
        
        var imgStudent: UIImageView!
        
        header.backgroundColor =  UIColor(red: 93/255, green: 155/255, blue: 197/255, alpha: 1)
        
        imgStudent = UIImageView(frame: CGRect(x: 75, y: 35, width:75, height: 75))
        imgStudent.image = image
        imgStudent.layer.cornerRadius = 20.0
        imgStudent.layer.masksToBounds = true
        
        header.addSubview(imgStudent)
        
        nameLabel.text = nameText
        nameLabel.textColor = UIColor.white
        header.addSubview(nameLabel)
            
        collegeNameLabel.text = idText
        collegeNameLabel.textColor = UIColor.white
        header.addSubview(collegeNameLabel)
            
        deptNameLabel.text = majorText
        deptNameLabel.textColor = UIColor.white
        header.addSubview(deptNameLabel)
        
        tableView.tableHeaderView = header
    }
    
    func postMyCourses(completed: @escaping () -> ()){
        guard let url = URL(string: "http://api.puroong.me/v1/users/\(idText)/exams") else { return }
                
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
                        let courses = try JSONDecoder().decode(CourseInfo.self, from: data)
                        self.myCourses = courses.exams
                        
                        DispatchQueue.main.async {
                            completed()
                        }
                
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
    
    private func setUptableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func logoutButtonPressed(){
        alertLogout()
    }
    
    func alertLogout(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default){
                (action) in
                self.accessToken = " "
                self.dismiss(animated: true, completion: nil)
            }
            let cancelAction = UIAlertAction(title: "취소", style: .destructive)
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func prepare(for segue:UIStoryboardSegue, sender: Any?){
        if let view = segue.destination as? SearchViewController{
            view.accessTokenString = accessToken
            view.userId = idText
        }
        if let view = segue.destination as? DetailViewController{
            view.course = myCourses[rowSelected]
            view.accessToken = accessToken
            view.userId = idText
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "search", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = myCourses[indexPath.row].title
        cell.detailTextLabel?.text = myCourses[indexPath.row].owner?.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        rowSelected = indexPath.row
        performSegue(withIdentifier: "showDetail", sender: self)
    }
}
