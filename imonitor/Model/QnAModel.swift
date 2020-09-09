//
//  QnAModel.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/01.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation

struct CourseExamInfo: Codable{
    let exam: OneExamInfo?
    
    enum CodingKeys: String, CodingKey{
        case exam = "exam"
    }
}

struct OneExamInfo: Codable{
    var id: Int
    var notice: String
    var owner: OwnerInfo
    var title: String
    var courseName: String
    var courseCode: String
    var startTime: String
    var endTime: String
    var questions: [QuestionInfo]
    var hasSubmitted: Bool
}

struct QuestionInfo: Codable{
    let id: Int?
    let question: String?
    let type: String?
    let choices: [ChoiceInfo]?
}

struct ChoiceInfo: Codable{
    let id: Int?
    let content: String?
    let order: Int?
}
