//
//  CourseModel.swift
//  imonitor
//
//  Created by 허예은 on 2020/08/22.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation


struct CourseInfo: Codable{
    let exams: [ExamInfo]
}

struct ExamInfo: Codable{
    let owner: UserInfo
    let title: String
    let courseName: String
    let courseCode: String
    let startTime: String
    let endTime: String
}

