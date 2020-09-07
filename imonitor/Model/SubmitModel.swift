//
//  SubmitModel.swift
//  imonitor
//
//  Created by 허예은 on 2020/09/06.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation

struct SubmitInfo: Codable{
    let result: [ResultInfo?]
}

struct ResultInfo: Codable{
    let qna: QuestionInfo
    let submittedAnswer: String
    let isCorrecet: Bool
}

struct Submit: Codable{
    let submits: SubmitParameter
}

struct SubmitParameter: Codable{
    var qnaId: Int
    var answer: String
}
