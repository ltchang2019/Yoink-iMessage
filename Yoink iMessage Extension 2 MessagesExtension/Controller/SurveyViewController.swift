//
//  ViewController.swift
//  TreeHacksApp2
//
//  Created by Luke Tchang on 2/14/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit
//import Firebase

protocol SurveyViewControllerDelegate{
    func dismissView()
}

class SurveyViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var submitButton: UIView!
    
    var surveyInfoArray: [SurveyInfo] = [
        SurveyInfo(number: 1, question: "Price?", answers: ["$", "$$", "$$$"]),
        SurveyInfo(number: 2, question: "Rating?", answers: ["⭑", "⭑⭑", "⭑⭑⭑", "⭑⭑⭑⭑", "⭑⭑⭑⭑⭑"]),
        SurveyInfo(number: 3, question: "Distance?", answers: ["Walking", "Biking", "Driving"])
    ]
    
    var answers: [Int] = [-1, -1, -1]
    var surveyAnswers: SurveyResponse!
    var personName: String!

    var sentCuisineAnswer: String!
    var delegate: SurveyViewControllerDelegate!
    
    override func viewDidLoad() {
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        collectionView?.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.reloadData()
        
        self.view.sendSubviewToBack(collectionView)
        submitButton.layer.cornerRadius = 10
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.submitResponses(_:)))
        submitButton.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    @objc func submitResponses(_ sender: UITapGestureRecognizer){
        if(checkForBlanks()){
            createSurveyResponseInstance()
            print("Price: \(surveyAnswers.price!)")
            print("Cuisine: \(surveyAnswers.cuisine!)")
            print("Rating: \(surveyAnswers.rating!)")
            print("Distance: \(surveyAnswers.distance!)")
            print(personName!)
            
            submitPreferences(completion: {() -> Void in
                self.delegate.dismissView()
            })
        } else {
            blankAlert()
        }
    }
    
    func submitPreferences(completion: @escaping () -> ()) {
      var URLString = "https://yoink-268306.appspot.com/dinners/MY6BZH/preferences?name=\(personName!)&rating=\(surveyAnswers.rating!)&price=\(surveyAnswers.price!)&cuisine=\(surveyAnswers.cuisine!)&distance=\(surveyAnswers.distance!)"
        
        var request = URLRequest(url: URL(string: URLString)!)
      request.httpMethod = "POST"
        
      let session = URLSession.shared
       
      let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        do {
          let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
          if let successStatus = json["status"] as? String {
            if successStatus == "OK" {
              completion()
            }
          }
        } catch {
            print("error!")
            completion()
        }
      })
       
      task.resume()
    }
    
    func createSurveyResponseInstance(){
        surveyAnswers = SurveyResponse(price: answers[0]+1, cuisine: sentCuisineAnswer!, rating: answers[1]+1, distance: surveyInfoArray[2].answers[answers[2]])
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




//CLASS FOR SNAPPY COLLECTION VIEW
class SnappingCollectionViewLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let verticalOffset = proposedContentOffset.x + collectionView.contentInset.right

        let targetRect = CGRect(x: proposedContentOffset.x, y: proposedContentOffset.y, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - verticalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - verticalOffset
            }
        })

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
