//
//  ScoreModel.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/08.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation

struct ScoreInfo: Codable{
    let result: [AnswerInfo]?
}

struct AnswerInfo: Codable{
    let qna: QnAInfo?
    let submittedAnswer: String?
    let isCorrect: Bool?
}

struct QnAInfo: Codable{
    let id: Int?
    let question: String?
    let answer: String?
    let type: String?
    let choices: [ChoiceInfo]?
}
