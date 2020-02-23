//
//  SurveyCell.swift
//  TreeHacksApp2
//
//  Created by Luke Tchang on 2/14/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

protocol SurveyCellDelegate {
    func changeAnswer(questionNumber: Int, newCheckedRow: Int)
}

import UIKit

class SurveyCell: UICollectionViewCell{
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answersTableView: UITableView!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var shadowView2: UIView!
    
    
    let cellHeightSpacing: CGFloat = 30
    
    var delegate: SurveyCellDelegate!
            
    var surveyInfo: SurveyInfo!{
        didSet{
            fillCell()
            answersTableView.dataSource = self
            answersTableView.delegate = self as! UITableViewDelegate
            answersTableView.allowsSelection = true
            answersTableView.backgroundColor = UIColor.clear
            answersTableView.separatorStyle = .none
            
            contentView.layer.cornerRadius = 20.0
            contentView.layer.borderColor = UIColor.white.cgColor
            contentView.layer.masksToBounds = true
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowOpacity = 0.2    // not recommend >0.25
            layer.shadowRadius = 5.0
            layer.masksToBounds = false
            layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.cornerRadius = 20.0
            gradientLayer.masksToBounds = true
            gradientLayer.colors = [getColorByHex(rgbHexValue: 0x2193b0).cgColor, getColorByHex(rgbHexValue: 0x6dd5ed).cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.frame = contentView.bounds
            contentView.layer.insertSublayer(gradientLayer, at: 0)
            
        }
    }
    
    func fillCell(){
        questionLabel.text = surveyInfo.question
        answersTableView.reloadData()
    }
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0

        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}

extension SurveyCell: UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return surveyInfo.answers.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerTableViewCell
        
        cell.answer = surveyInfo.answers[indexPath.section]
//        cell.accessoryType = cell.checked ? .checkmark : .none
        
        return cell
     }
    
}

extension SurveyCell: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellHeightSpacing
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.reloadData()
        if let cell = tableView.cellForRow(at: indexPath) as? AnswerTableViewCell{
            for otherCell in tableView.visibleCells as! [AnswerTableViewCell]{
                if(otherCell.checked){
                    otherCell.checked = false
                    otherCell.updateCell()
                }
            }
            
            cell.checked = true
            cell.updateCell()
            delegate.changeAnswer(questionNumber: surveyInfo.number!, newCheckedRow: indexPath.section)
        }
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }

        return nil
    }
}



