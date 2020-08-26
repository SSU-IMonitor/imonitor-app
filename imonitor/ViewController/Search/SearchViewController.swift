//
//  SearchViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/22.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit
import Alamofire

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    var accessTokenString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SearchAPI()


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
    
    func SearchAPI(){
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
                        print(course.exams)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }

}
    
//    static func search(_ term: String, completion: @escaping ([Course]) -> Void){
//        let session  = URLSession(configuration: .default)
//
//        var urlComponents = URLComponents(string: ""http://api.puroong.me/v1/exams"")!
//        let termQuery = URLQueryItem(name: "term", value: term)
//        urlComponents.queryItems?.append(termQuery)
//
//        let requestURL = urlComponents.url!
//        print(requestURL)
//
//        let dataTask = session.dataTask(with: requestURL){
//            (data, response, error) in
//            let successRange = 200..<300
//
//            guard error == nil,
//                let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
//                    completion([])
//                    return
//            }
//
//            guard let resultData = data else {
//                completion([])
//                return
//            }
//
//            // data -> [Course]
//            let string = String(data: resultData, encoding: .utf8)
//            print("--> result: \(string)")
////            completion([Course])
//
//        }.resume()
//
//    }
