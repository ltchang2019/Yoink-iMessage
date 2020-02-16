//
//  ViewController.swift
//  TreeHacksApp2
//
//  Created by Luke Tchang on 2/14/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit
//import Firebase

class SurveyViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var overallView: UIView!
    @IBOutlet weak var submitButton: UIView!
    
    var surveyInfoArray: [SurveyInfo] = [
        SurveyInfo(number: 1, question: "Price?", answers: ["$", "$$", "$$$"]),
        SurveyInfo(number: 2, question: "Cuisine?", answers: ["American", "Mexican", "Chinese"]),
        SurveyInfo(number: 3, question: "Rating?", answers: ["⭑", "⭑⭑", "⭑⭑⭑", "⭑⭑⭑⭑", "⭑⭑⭑⭑⭑"]),
        SurveyInfo(number: 4, question: "Distance?", answers: ["Walking", "Biking", "Driving"])
    ]
    
    var answers: [Int] = [-1, -1, -1, -1]
    var surveyAnswers: SurveyResponse!
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.reloadData()
        
        self.view.sendSubviewToBack(collectionView)
        submitButton.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.submitResponses(_:)))
        submitButton.addGestureRecognizer(tap)
        
    }
    
    @objc func submitResponses(_ sender: UITapGestureRecognizer){
        if(checkForBlanks()){
        
        createSurveyResponseInstance()
        print("Price: \(surveyAnswers.price!)")
        print("Cuisine: \(surveyAnswers.cuisine!)")
        print("Rating: \(surveyAnswers.rating!)")
        print("Distance: \(surveyAnswers.distance!)")
        //SEND DATA TO DATABASE
        } else {
            blankAlert()
        }
    }
    
    func createSurveyResponseInstance(){
        surveyAnswers = SurveyResponse(price: answers[0]+1, cuisine: surveyInfoArray[1].answers[answers[1]], rating: answers[2]+1, distance: surveyInfoArray[3].answers[answers[3]])
    }
    
    func checkForBlanks() -> Bool {
        for x in answers{
            if(x < 0) {return false}
        }
        return true
    }
    
    func blankAlert(){
        let alertController = UIAlertController(title: "Incomplete", message:
            "Please answer all questions!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension SurveyViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return surveyInfoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SurveyCell", for: indexPath) as! SurveyCell
        cell.surveyInfo = surveyInfoArray[indexPath.row]
        cell.answersTableView.reloadData()
        cell.delegate = self
        
        return cell
    }
}

extension SurveyViewController: SurveyCellDelegate{
    
    func changeAnswer(questionNumber: Int, newCheckedRow: Int) {
        answers[questionNumber-1] = newCheckedRow
        print(answers)
    }
}
