//
//  SignUpModel.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/18.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation

struct RegisterInfo: Codable {
    let id: String
    let name: String
    let password: String
    let major: String
    
    init(id : String, name: String, password: String, major: String){
        self.id = id
        self.name = name
        self.password = password
        self.major = major
    }
}
