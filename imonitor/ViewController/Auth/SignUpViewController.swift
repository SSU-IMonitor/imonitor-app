//
//  SignUpViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/12.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var majorTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordVerifiedTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDoneButton()

        // Do any additional setup after loading the view.
    }
    
    func createDoneButton(){
        nameTextField.addDoneButtonOnKeyboard()
        majorTextField.addDoneButtonOnKeyboard()
        idTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
        passwordVerifiedTextField.addDoneButtonOnKeyboard()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "login") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        SignUpParsing()
        present(vc, animated: true)
    }
    
    func SignUpParsing(){
        let parameters = ["id": idTextField.text, "name": nameTextField.text, "password": passwordTextField.text, "major": majorTextField.text]
        
        guard let url = URL(string: "http://api.puroong.me/v1/auth/sign-up") else { return }
        
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
                    print("Status Code: ", myResponse.statusCode)
                    
                    if myResponse.statusCode == 200{
                        let log = try JSONDecoder().decode(LoginInfo.self, from: data)
                        print("id:", log.userInfo.id, "\tname: ", log.userInfo.name)
                        print("회원가입 정상 완료")
                        
                    } else if myResponse.statusCode == 500{
                        print("회원 중복")
                        
                    } else {
                        let error = try JSONDecoder().decode(ErrorInfo.self, from: data)
                        print(error.message)
                    }
                } catch{
                    print("error: ", error)
                }
            }
        }.resume()
    }
}
