//
//  DinnerStatusButtonsViewController.swift
//  Yoink iMessage Extension 2 MessagesExtension
//
//  Created by Luke Tchang on 2/22/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit

class FloatingPanelViewController: UIViewController{
    
    @IBOutlet weak var submitPreferencesButton: UIButton!
    @IBOutlet weak var getRecommendationsButton: UIButton!
    
    override func viewDidLoad() {
        customizeTwoButtons()
    }
    
    @IBAction func submitPreferencesPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSurvey", sender: self)
        
    }
    @IBAction func getRecommendationsPressed(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSurvey"{
            let surveyVC = segue.destination as! CuisineSearchViewController
            surveyVC.delegate = self as! CuisineSearchControllerDelegate
        }
    }
}

extension FloatingPanelViewController: CuisineSearchControllerDelegate{
        func refreshTable() {
//            getRespondents {
//                DispatchQueue.main.async {
//    //                 self.respondentsListTableView.reloadData()
//                }
//            }
    }
}

extension FloatingPanelViewController{
    func customizeTwoButtons(){
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.cornerRadius = 20.0
        gradientLayer1.masksToBounds = true
        gradientLayer1.colors = [getColorByHex(rgbHexValue: 0x2193b0).cgColor, getColorByHex(rgbHexValue: 0x6dd5ed).cgColor]
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer1.frame = submitPreferencesButton.bounds
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.cornerRadius = 20.0
        gradientLayer2.masksToBounds = true
        gradientLayer2.colors = [getColorByHex(rgbHexValue: 0x2193b0).cgColor, getColorByHex(rgbHexValue: 0x6dd5ed).cgColor]
        gradientLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer2.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer2.frame = getRecommendationsButton.bounds
        
        submitPreferencesButton.layer.shadowColor = UIColor.black.cgColor
        submitPreferencesButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        submitPreferencesButton.layer.shadowOpacity = 0.2
        submitPreferencesButton.layer.shadowRadius = 5.0
        submitPreferencesButton.layer.insertSublayer(gradientLayer1, at: 0)
        submitPreferencesButton.setTitleColor(UIColor.white, for: .normal)
               
        getRecommendationsButton.layer.shadowColor = UIColor.black.cgColor
        getRecommendationsButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        getRecommendationsButton.layer.shadowOpacity = 0.2
        getRecommendationsButton.layer.shadowRadius = 5.0
        getRecommendationsButton.layer.insertSublayer(gradientLayer2, at: 0)
        getRecommendationsButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0

        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
}
