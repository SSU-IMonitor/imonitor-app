//
//  LoginViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/07/30.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var signinButton: UIButton!
    
    var idText: String = ""
    var majorText: String = ""
    var nameText: String = ""
    
    var delegate: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(){

        let vc = storyboard?.instantiateViewController(identifier: "main") as! MainViewController
        
        vc.modalPresentationStyle = .fullScreen
        userInfoParsing()
        vc.idText = self.idText
        vc.nameText = self.nameText
        vc.majorText = self.majorText
        
        present(vc, animated: true)
    }
    
    func userInfoParsing(){
        let parameters = ["id": idTextField.text, "password": passwordTextField.text]

        //guard let url = URL(string: "https://stoplight.io/p/mocks/13917/150793/v1/auth/sign-in") else { return }
        guard let url = URL(string: "http://api.puroong.me/v1/auth/sign-in") else { return }
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }

        request.httpBody = httpBody;

        let session = URLSession.shared
        session.dataTask(with: request){
            (data, response, error) in
                
            if let data = data {
                do {
            //                    codable 사용하지 않았을 경우
            //                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
            //                    print(json)
            //
            //                    let userInfo = (json["userInfo"] ?? "")
            //                    print(userInfo)
            //          codable 사용한 경우
                    let myResponse = response as! HTTPURLResponse
                        print("Status Code:", myResponse.statusCode)
                        
                    if myResponse.statusCode != 200 {
                        let error = try JSONDecoder().decode(ErrorInfo.self, from: data)
                        print(error.message)
                    } else {
                        let user = try JSONDecoder().decode(LoginInfo.self, from: data)
                            
                        print(user.userInfo.id)
                        self.idText = user.userInfo.id
                        self.nameText = user.userInfo.name
                        self.majorText = user.userInfo.major
                    }
    //                    self.inserData(name: user.userInfo.name, id: user.userInfo.id, major: user.userInfo.major)
                } catch {
                    //let error = try JSONDecoder.decode(ErrorInfo.self, from: data)
                    print("error: ", error)
                }
            }
        }.resume()
    }
    
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "signUp") as! SignUpViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

//class CourseViewModel{
//    let courseInfoList:[CourseInfo] = [
//        CourseInfo(course:"데이터베이스응용", professor: "이상호", courseCode: "2050301", startTime:"2020.08.07 15:00:00", endTime: "2020.08.07 16:00:00", notice: "본 시험은 시험 기간 이후 접속할 시 접속할 수 없습니다. 그러니 주의하시고 시험 시간 몇 분전에 미리 접속하여 시험을 볼 수 있는 환경을 만들어 놓으시길 바랍니다."),
//        CourseInfo(course:"운영체제", professor: "양승민", courseCode: "3020594", startTime:"2020.08.09 15:00:00", endTime: "2020.08.09 16:00:00", notice: "본 시험은 시험 기간 이후 접속할 시 접속할 수 없습니다. 그러니 주의하시고 시험 시간 몇 분전에 미리 접속하여 시험을 볼 수 있는 환경을 만들어 놓으시길 바랍니다."),
//        CourseInfo(course:"시스템프로그래밍", professor: "최재영", courseCode: "342456", startTime:"2020.08.11 15:00:00", endTime: "2020.08.11 16:00:00", notice: "본 시험은 시험 기간 이후 접속할 시 접속할 수 없습니다. 그러니 주의하시고 시험 시간 몇 분전에 미리 접속하여 시험을 볼 수 있는 환경을 만들어 놓으시길 바랍니다.")
//    ]
//
//    var numofCourseInfo: Int{
//        return courseInfoList.count
//    }
//
//    func courseInfo(at index: Int) -> CourseInfo{
//        return courseInfoList[index]
//    }
//}
