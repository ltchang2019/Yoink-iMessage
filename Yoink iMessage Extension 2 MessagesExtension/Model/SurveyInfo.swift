//
//  SurveyInfo.swift
//  TreeHacksApp2
//
//  Created by Luke Tchang on 2/14/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import Foundation

class SurveyInfo
{
    var number: Int!
    var question: String!
    var answers: [String]!
    
    init(number: Int, question: String, answers: [String]){
        self.number = number
        self.question = question
        self.answers = answers
    }
    
}
