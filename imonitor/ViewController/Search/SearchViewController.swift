//
//  SearchViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/22.
//  Copyright © 2020 허예은. All rights reserved.
//
import UIKit
import Alamofire

var count: Int = 0

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var accessTokenString: String = ""
    var userId: String = ""
    var courses = [ExamInfo]()
    var filteredCourses = [ExamInfo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        SearchAPI {
            self.tableView.reloadData()
        }
        setUptableView()
        setUpSearchBar()
        
        filteredCourses = courses
    }
    
    private func setUptableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpSearchBar(){
        searchBar.delegate = self
    }
    
    private func dismissKeyboard(){
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 키보드가 올라와 있을 때, 내려가게 처리
        dismissKeyboard()
        
        // 검색어가 있는지. 없으면 아래의 작업을 수행할 수 없음.
        guard let searchTerm = searchBar.text, searchTerm.isEmpty == false else { return }
        
        //print("--> 검색어: \(searchBar.text)")
    }
    
    func SearchAPI(completed: @escaping () -> ()){
        let url = URL(string: "http://api.puroong.me/v1/exams")
        
        guard let requestURL = url else { fatalError() }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + accessTokenString, forHTTPHeaderField: "Authorization")
        
        print("access: \(accessTokenString)" )
        
        let session = URLSession.shared
        session.dataTask(with: request) {
            (data, response, error) in
            
            if let data = data {
                do {
                    let myResponse = response as! HTTPURLResponse
                    print("Status Code:", myResponse.statusCode)
                                
                    if myResponse.statusCode == 200 {
                        let course = try JSONDecoder().decode(CourseInfo.self, from: data)
                        self.courses = course.exams
                        
                        print(self.courses)
                        
                        DispatchQueue.main.async {
                            completed()
                        }
                        
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            filteredCourses = courses
            return
        }
        
        filteredCourses = courses.filter({course -> Bool in
        guard let text = searchBar.text else { return false }
            
            if searchBar.text == course.courseCode {
                return course.courseCode!.contains(text)
            }
                   
            if searchBar.text == course.courseName {
                return course.courseName!.contains(text)
            }
               
            if searchBar.text == course.title {
                return course.title!.contains(text)
            }
               
            return false
        })
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCourses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = filteredCourses[indexPath.row].title
        cell.detailTextLabel?.text = filteredCourses[indexPath.row].courseCode
        return cell
    }

   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 80.0
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        alertAddCourse(indexPath: indexPath)
    }
    
    func alertAddCourse(indexPath: IndexPath){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "해당 과목을 추가하시겠습니까?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default){
                (action) in
                self.postMyExam(indexPath: indexPath)
            }
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func postMyExam(indexPath: IndexPath){
        let parameters = ["examId": filteredCourses[indexPath.row].id!];
        
        guard let url = URL(string: "http://api.puroong.me/v1/users/\(userId)/exams") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        //request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer " + accessTokenString, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }

        request.httpBody = httpBody;
        
        let session = URLSession.shared
        session.dataTask(with: request){
            (data, response, error) in
                
            if let data = data {
                do {
                    let myResponse = response as! HTTPURLResponse
                        print("Status Code:", myResponse.statusCode)
                    
                    if myResponse.statusCode == 200 {
                        let course = try JSONDecoder().decode(MyCourseInfo.self, from: data)
                        print(course.exam as Any)
                        self.alertLogin()
                        
                    } else if myResponse.statusCode == 404 || myResponse.statusCode == 500 {
                        print(myResponse.statusCode)
                    } else if myResponse.statusCode == 409 {
                        self.alertDuplicatedMyCourse()
                    }
                    else {
                        let error = try JSONDecoder().decode(ErrorInfo.self, from: data)
                        print(error.message)
                    }
                } catch {
                    print("error: ", error)
                }
            }
        }.resume()
    }
    
    func alertLogin(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "과목이 추가되었습니다. \n재로그인 후 과목 업로드 됩니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func alertDuplicatedMyCourse(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "경고", message: "이미 추가한 과목입니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
