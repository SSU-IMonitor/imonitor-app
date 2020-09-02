//
//  QnAModel.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/01.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation

struct CourseExamInfo: Codable{
    let exam: ExamInfo?
    
    enum CodingKeys: String, CodingKey{
        case exam = "exams"
    }
}

struct QuestionInfo: Codable{
    let id: String?
    let question: String?
    let type: String?
    let choices: [ChoiceInfo]?
}

struct ChoiceInfo: Codable{
    let id: String?
    let content: String?
    let order: Int?
}
