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
    let id: Int?
    let notice: String?
    let owner: OwnerInfo?
    let title: String?
    let courseName: String?
    let courseCode: String?
    let startTime: String?
    let endTime: String?
    let questions: [QuestionInfo]?
    
    enum CodingKeys: String, CodingKey{
        case id
        case notice
        case owner = "owner"
        case title
        case courseName
        case courseCode
        case startTime
        case endTime
        case questions
    }
    
    init(id: Int, notice: String, owner: OwnerInfo, title: String, courseName: String, courseCode: String, startTime: String, endTime: String, questions: [QuestionInfo]){
        self.id = id
        self.notice = notice
        self.owner = owner
        self.title = title
        self.courseName = courseName
        self.courseCode = courseCode
        self.startTime = startTime
        self.endTime = endTime
        self.questions = questions
    }
}

struct OwnerInfo: Codable{
    let id: String
    let major: String
    let name: String
}

