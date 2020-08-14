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
        present(vc, animated: true)
    }
    
}
