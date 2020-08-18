//
//  LoginModel.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/18.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation

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
}

