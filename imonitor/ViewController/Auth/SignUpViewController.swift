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
    }
    
    func createDoneButton(){
        nameTextField.addDoneButtonOnKeyboard()
        majorTextField.addDoneButtonOnKeyboard()
        idTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
        passwordVerifiedTextField.addDoneButtonOnKeyboard()
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
       postRegister()
    }
    
    func postRegister(){
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
                       
                    if myResponse.statusCode == 200{
                        // let log = try JSONDecoder().decode(LoginInfo.self, from: data)
                        
                        self.moveToLogin()
                           
                    } else if myResponse.statusCode == 500{
                        self.alertUserDuplicated()
                           
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
    
    func moveToLogin(){
        let vc = storyboard?.instantiateViewController(identifier: "login") as! LoginViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func alertUserDuplicated(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "경고", message: "회원 중복. 다른 학번을 사용해주세요", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default){
                (action) in self.idTextField.text = ""
            }
                   
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func exitSignUpPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
