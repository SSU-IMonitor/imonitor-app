//
//  SignUpViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/12.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SignUpViewController: UIViewController {
    private let registerViewModel = RegisterViewModel()
    private let disposeBag = DisposeBag()

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var majorTextField: UITextField!
    @IBOutlet var idTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordVerifiedTextField: UITextField!
    
    @IBOutlet var signUpButton: UIRoundPrimaryButton!
    
    @IBOutlet var wrongPasswordImageView: UIImageView!
    @IBOutlet var wrongPasswordVerifiedImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDoneButton()
        rxRegister()
    }
    
    func createDoneButton(){
        nameTextField.addDoneButtonOnKeyboard()
        majorTextField.addDoneButtonOnKeyboard()
        idTextField.addDoneButtonOnKeyboard()
        passwordTextField.addDoneButtonOnKeyboard()
        passwordVerifiedTextField.addDoneButtonOnKeyboard()
    }
    
    func rxRegister(){
        nameTextField.becomeFirstResponder()
           
        nameTextField.rx.text.map {$0 ?? ""}.bind(to: registerViewModel.nameTextPublishSubject).disposed(by: disposeBag)
        
        majorTextField.rx.text.map {$0 ?? ""}.bind(to: registerViewModel.majorTextPublishSubject).disposed(by: disposeBag)
        
        idTextField.rx.text.map {$0 ?? ""}.bind(to: registerViewModel.idTextPublishSubject).disposed(by: disposeBag)
        
        passwordTextField.rx.text.map {$0 ?? ""}.bind(to: registerViewModel.passwordTextPublishSubject).disposed(by: disposeBag)
        
        passwordVerifiedTextField.rx.text.map {$0 ?? ""}.bind(to: registerViewModel.passwordCheckTextPublishSubject).disposed(by: disposeBag)
        
        registerViewModel.isValid().bind(to: signUpButton.rx.isEnabled).disposed(by: disposeBag)
        registerViewModel.isValid().map{ $0 ? 1 : 0.1}.bind(to: signUpButton.rx.alpha).disposed(by: disposeBag)
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        comparePassword()
    }
    
    func comparePassword(){
        if String(passwordTextField.text!) == String(passwordVerifiedTextField.text!){
            wrongPasswordImageView.image = nil
            wrongPasswordVerifiedImageView.image = nil
            postRegister()
        } else {
            wrongPasswordImageView.image = UIImage(named: "wrong.png")
            wrongPasswordVerifiedImageView.image = UIImage(named: "wrong.png")
            
            alertPasswordNotCorrect()
        }
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
            let alert = UIAlertController(title: "경고", message: "회원 중복. 다른 학번을 사용해주세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default){
                (action) in self.idTextField.text = ""
            }
                   
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func alertPasswordNotCorrect(){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "경고", message: "비밀번호가 일치하지 않습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .default){
                (action) in
                self.passwordTextField.text = ""
                self.passwordVerifiedTextField.text = ""
            }
                          
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func exitSignUpPage(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

class RegisterViewModel{
    let nameTextPublishSubject = PublishSubject<String>()
    let majorTextPublishSubject = PublishSubject<String>()
    let idTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    let passwordCheckTextPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(nameTextPublishSubject.asObservable().startWith(""), majorTextPublishSubject.asObservable().startWith(""), idTextPublishSubject.asObservable().startWith(""), passwordCheckTextPublishSubject.asObservable().startWith(""),nameTextPublishSubject.asObservable().startWith("")).map{
            name, major, id, password, passwordCheck in
            return name.count >= 2 && major.count >= 1 && id.count >= 8 && password.count >= 1 && passwordCheck.count >= 1
        }.startWith(false)
    }
}
