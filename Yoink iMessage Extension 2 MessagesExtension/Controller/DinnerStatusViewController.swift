//
//  DinnerStatusViewController.swift
//  Yoink iMessage Extension 2 MessagesExtension
//
//  Created by Luke Tchang on 2/15/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit

protocol DinnerStatusDelegate {
    func sendRecMessage(restaurantName: String, similarity: Double)
}

class DinnerStatusViewController: UIViewController{
    
    @IBOutlet weak var respondentsListTableView: UITableView!
    @IBOutlet weak var fillSurveyView: UIView!
    @IBOutlet weak var getRecommendationView: UIView!
    
    var respondentsList: [String] = []
    var delegate: DinnerStatusDelegate!
    
@objc func getRecommendation(_ sender: Any) {
        print("Get Recommendation Pressed")
        getRec { (name, similarity) in
            print(name, similarity)
            self.delegate.sendRecMessage(restaurantName: name, similarity: similarity)
        }
}
    
@objc func openSurvey(_ sender: Any) {
    performSegue(withIdentifier: "toSurvey", sender: self)
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "toSurvey"{
        let surveyVC = segue.destination as! CuisineSearchViewController
        surveyVC.delegate = self as! CuisineSearchControllerDelegate
    }
}

    
    override func viewDidLoad() {
        respondentsListTableView.dataSource = self
        respondentsListTableView.delegate = self as! UITableViewDelegate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRespondents {
            DispatchQueue.main.async {
                self.respondentsListTableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        fillSurveyView.layer.cornerRadius = 10
        getRecommendationView.layer.cornerRadius = 10
        
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.getRecommendation(_:)))
        getRecommendationView.addGestureRecognizer(tap1)
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.openSurvey(_:)))
        fillSurveyView.addGestureRecognizer(tap2)
        
    }
    
    func getRespondents(completion: @escaping () -> ()){
        var URLString = "https://yoink-268306.appspot.com/dinners/MY6BZH/preferences"
          
        var request = URLRequest(url: URL(string: URLString)!)
        request.httpMethod = "GET"
          
        let session = URLSession.shared
         
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
          do {
            let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, AnyObject>
            if let successStatus = json["status"] as? String {
              if successStatus == "OK" {
                if let results = json["result"] as? Array<Dictionary<String, AnyObject>>{
                    var tempList: [String] = []
                    for object in results{
                        if let name = object["name"] as? String{
                            tempList.append(name)
                            completion()
                        }
                    }
                    self.respondentsList = tempList
                }
              }
            }
          } catch {
              print("error!")
              completion()
          }
        })
        task.resume()
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


extension DinnerStatusViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return respondentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RespondentCell", for: indexPath)
        cell.textLabel?.text = respondentsList[indexPath.row]
        
        return cell
    }
    
    
}

extension DinnerStatusViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}

extension DinnerStatusViewController: CuisineSearchControllerDelegate{
    func refreshTable() {
        getRespondents {
            DispatchQueue.main.async {
                self.respondentsListTableView.reloadData()
            }
        }
    }
}
