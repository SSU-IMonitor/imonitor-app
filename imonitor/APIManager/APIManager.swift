//
//  APIManager.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/18.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation
import Alamofire

class APIManager {
    static let shareInstance = APIManager()
    
    func cellingRegisterAPI(register: RegisterInfo){
        let headers: HTTPHeaders = [
        .contentType("application/json")]
        
        AF.request(register_url, method: .post, parameters: register, encoder: JSONParameterEncoder.default, headers: headers).response{
            response in debugPrint(response)
        }
    }
}
