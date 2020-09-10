//
//  LoginViewController.swift
//  imonitor
//
//  Created by 허예은 on 2020/07/30.
//  Copyright © 2020 허예은. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class LoginViewController: UIViewController {
    private let loginViewModel = LoginViewModel()
    private let disposeBag = DisposeBag()

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
        
        idTextField.becomeFirstResponder()
        
        idTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.idTextPublishSubject).disposed(by: disposeBag)
        passwordTextField.rx.text.map {$0 ?? ""}.bind(to: loginViewModel.passwordTextPublishSubject).disposed(by: disposeBag)
        
        loginViewModel.isValid().bind(to: signinButton.rx.isEnabled).disposed(by: disposeBag)
        loginViewModel.isValid().map{ $0 ? 1 : 0.1}.bind(to: signinButton.rx.alpha).disposed(by: disposeBag)
    }
    
    @IBAction func loginButtonPressed(){
        postLogin()
    }
    
    func postLogin(){
        let parameters = ["id": idTextField.text, "password": passwordTextField.text]

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
                        
                        DispatchQueue.main.async {
                            self.idText = user.userInfo.id
                            self.nameText = user.userInfo.name
                            self.majorText = user.userInfo.major
                            self.accessToken = user.accessToken
                            self.setLoading()
                        }
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
    
    func setLoading(){
        let loading = NVActivityIndicatorView(frame: .zero, type: .ballScaleMultiple, color: UIColor(red: 93/255, green: 155/255, blue: 197/255, alpha: 1), padding: 0)
        loading.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.widthAnchor.constraint(equalToConstant: 60),
            loading.heightAnchor.constraint(equalToConstant: 60),
            loading.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loading.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        loading.startAnimating()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.5){
            loading.stopAnimating()
            self.moveToMain()
        }
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

class LoginViewModel{
    let idTextPublishSubject = PublishSubject<String>()
    let passwordTextPublishSubject = PublishSubject<String>()
    
    func isValid() -> Observable<Bool> {
        Observable.combineLatest(idTextPublishSubject.asObservable().startWith(""), passwordTextPublishSubject.asObservable().startWith("")).map{
            id, password in
            return id.count >= 8 && password.count >= 8
        }.startWith(false)
    }
}
