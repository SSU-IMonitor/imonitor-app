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
        
        // 네트워킹을 통한 검색
        // - 목표: 서치텀을 가지고 네트워킹을 통해서 영화 검색
        // - 검색 API 필요
        // - 결과를 받아오는 모델 (Course, response)
        // - 결과를 받아와서 table view로 표현
        
       
        print("--> 검색어: \(searchBar.text)")
        
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
        alertAddCourse()
    }
    
    func alertAddCourse(){
         DispatchQueue.main.async {
            let alert = UIAlertController(title: "알림", message: "해당 과목을 추가하시겠습니까?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
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
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }
}
