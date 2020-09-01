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
    var accessToken: String = ""
    
    var delegate: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(){
            loginAPI()
    }
    
    func loginAPI(){
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
                    let myResponse = response as! HTTPURLResponse
                        print("Status Code:", myResponse.statusCode)
                    
                    if myResponse.statusCode == 200 {
                        let user = try JSONDecoder().decode(LoginInfo.self, from: data)
                        print(user.userInfo.id)
                        
                        self.idText = user.userInfo.id
                        self.nameText = user.userInfo.name
                        self.majorText = user.userInfo.major
                        self.accessToken = user.accessToken
                        print("login accessToken: \(self.accessToken)")
                        self.moveToMain()
                        
                    } else if myResponse.statusCode == 404 || myResponse.statusCode == 500 {
                        self.alert()
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
    
    func moveToMain(){
        DispatchQueue.main.async {
            let vc = self.storyboard?.instantiateViewController(identifier: "main") as! MainViewController
            vc.modalPresentationStyle = .fullScreen
            vc.idText = self.idText
            vc.nameText = self.nameText
            vc.majorText = self.majorText
            vc.accessToken = self.accessToken
                          
            self.present(vc, animated: true)
        }
    }
    
    func alert(){
         DispatchQueue.main.async {
            let alert = UIAlertController(title: "경고", message: "아이디 또는 비밀번호를 잘못 입력하셨습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
