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
        present(vc, animated: true)
        
        
        let parameters = ["student ID": idTextField.text, "password": passwordTextField.text]
        
        guard let url = URL(string: "https://stoplight.io/p/mocks/13917/150793//auth/sign-in") else { return }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody;
        
        let session = URLSession.shared
        session.dataTask(with: request){
            (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
}
