//
//  DinnerStatusButtonsViewController.swift
//  Yoink iMessage Extension 2 MessagesExtension
//
//  Created by Luke Tchang on 2/22/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit

protocol FloatingPanelViewControllerDelegate {
    func sendInfoToMessageController(restaurantName: String, similarity: Double)
}

class FloatingPanelViewController: UIViewController{
    
    @IBOutlet weak var submitPreferencesButton: UIButton!
    @IBOutlet weak var getRecommendationsButton: UIButton!
    var delegate: FloatingPanelViewControllerDelegate!
    
    
    override func viewDidLoad() {
//        NSLayoutConstraint.activate([
//            self.view.heightAnchor.constraint(equalToConstant: 20)
//        ])
        customizeTwoButtons()
    }
    
    @IBAction func submitPreferencesPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSurvey", sender: self)
        
    }
    @IBAction func getRecommendationsPressed(_ sender: Any) {
        print("Get Recommendation Pressed")
        getRec { (name, similarity) in
            print(name, similarity)
            self.delegate.sendInfoToMessageController(restaurantName: name, similarity: similarity)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSurvey"{
            let surveyVC = segue.destination as! CuisineSearchViewController
            surveyVC.delegate = self.delegate as! CuisineSearchControllerDelegate
        }
    }
    
    func getRec(completion: @escaping (_ name: String, _ similarity: Double) -> ()){
        var URLString = "https://yoink-268306.appspot.com/dinners/MY6BZH/recommend"
          
        var request = URLRequest(url: URL(string: URLString)!)
        request.httpMethod = "GET"
          
        let session = URLSession.shared
         
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
          do {
            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
            if let successStatus = json["status"] as? String {
              if successStatus == "OK" {
                if let result = json["result"] as? Dictionary<String, AnyObject>{
                    if let name = result["resturant_name"] as? String, let similarity = result["similarity"] as? Double{
                        completion(name, similarity)
                    }
                }
              }
            }
          } catch {
              print("error!")
              completion("bad", 0.0)
          }
        })
        task.resume()
    }
}

extension FloatingPanelViewController{
    func customizeTwoButtons(){
        submitPreferencesButton.layer.cornerRadius = 5
        getRecommendationsButton.layer.cornerRadius = 5
    }
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0

        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    
}
