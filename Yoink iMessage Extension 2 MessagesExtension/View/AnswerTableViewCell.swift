//
//  AnswerTableViewCell.swift
//  TreeHacksApp2
//
//  Created by Luke Tchang on 2/15/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell{
    
    @IBOutlet weak var answerLabel: UILabel!
    
    var checked: Bool = false
    var answer: String!{
        didSet{
            updateCell()
        }
    }
    
    func updateCell(){
        answerLabel.text = answer
        if(checked){
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
        
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
}
