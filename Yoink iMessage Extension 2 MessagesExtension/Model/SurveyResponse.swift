//
//  SurveyResponse.swift
//  TreeHacksApp2
//
//  Created by Luke Tchang on 2/15/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import Foundation

class SurveyResponse{
    var price: Int!
    var cuisine: String!
    var rating: Int!
    var distance: String!
    
    init(price: Int, cuisine: String, rating: Int, distance: String){
        self.price = price
        self.cuisine = cuisine
        self.rating = rating
        self.distance = distance
    }
    
}
