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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(){
        let vc = storyboard?.instantiateViewController(identifier: "main") as! MainViewController
        vc.modalPresentationStyle = .fullScreen
        
        let parameters = ["id": idTextField.text, "password": passwordTextField.text]

        guard let url = URL(string: "https://stoplight.io/p/mocks/13917/150793/v1/auth/sign-in") else { return }
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }

        request.httpBody = httpBody;

        let session = URLSession.shared
        session.dataTask(with: request){
            (data, response, error) in
//            if let response = response {
//                print(response)
//            }

            if let data = data {
                do {
//                    codable 사용하지 않았을 경우
//                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String : Any]
//                    print(json)
//
//                    let userInfo = (json["userInfo"] ?? "")
//                    print(userInfo)
                    
//                    codable 사용한 경우
                    let user = try JSONDecoder().decode(LoginInfo.self, from: data)
                    print(user.userInfo.major)
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        present(vc, animated: true)
    }
    
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "signUp") as! SignUpViewController
               vc.modalPresentationStyle = .fullScreen
               present(vc, animated: true)
    }
    
}

struct LoginInfo: Codable{
    let accessToken: String
    let refreshToken: String
    let tokenType: String
    let userInfo: UserInfo
}

struct UserInfo: Codable{
    let id: String
    let major: String
    let name: String
    
    func getString(){
        print("id: \(id), major: \(major), name: \(name)")
    }
}
