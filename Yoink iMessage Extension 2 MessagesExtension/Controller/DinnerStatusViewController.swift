//
//  DinnerStatusViewController.swift
//  Yoink iMessage Extension 2 MessagesExtension
//
//  Created by Luke Tchang on 2/15/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit
import MapKit
import FloatingPanel

protocol DinnerStatusDelegate {
    func sendRecMessage(restaurantName: String, similarity: Double)
}

class DinnerStatusViewController: UIViewController, FloatingPanelControllerDelegate{
    
    @IBOutlet weak var respondentsListTableView: UITableView!
    @IBOutlet weak var fillSurveyView: UIButton!
    @IBOutlet weak var getRecommendationView: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonsView: UIView!
    
    
    var respondentsList: [String] = []
    var delegate: DinnerStatusDelegate!
    var fpc: FloatingPanelController!
    
    override func viewDidLoad() {
        setUpMapView()
//        customizeTwoButtons()
        setUpFloatingPanel()
//        respondentsListTableView.dataSource = self
//        respondentsListTableView.delegate = self as! UITableViewDelegate
    }
    
    func setUpMapView(){
        let location = CLLocationCoordinate2D(latitude: 51.50007773,
            longitude: -0.1246402)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Big Ben"
        annotation.subtitle = "London"
        mapView.addAnnotation(annotation)
    }
    
    func setUpFloatingPanel(){
        fpc = FloatingPanelController()
        fpc.delegate = self as FloatingPanelControllerDelegate
        let contentVC = storyboard?.instantiateViewController(identifier: "FloatingPanelVC") as! FloatingPanelViewController
            
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
    }
    
    func customizeTwoButtons(){
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.cornerRadius = 20.0
        gradientLayer1.masksToBounds = true
        gradientLayer1.colors = [getColorByHex(rgbHexValue: 0x2193b0).cgColor, getColorByHex(rgbHexValue: 0x6dd5ed).cgColor]
        gradientLayer1.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer1.frame = fillSurveyView.bounds
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.cornerRadius = 20.0
        gradientLayer2.masksToBounds = true
        gradientLayer2.colors = [getColorByHex(rgbHexValue: 0x2193b0).cgColor, getColorByHex(rgbHexValue: 0x6dd5ed).cgColor]
        gradientLayer2.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer2.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer2.frame = getRecommendationView.bounds
        
        fillSurveyView.layer.shadowColor = UIColor.black.cgColor
        fillSurveyView.layer.shadowOffset = CGSize(width: 0, height: 0)
        fillSurveyView.layer.shadowOpacity = 0.2
        fillSurveyView.layer.shadowRadius = 5.0
        fillSurveyView.layer.insertSublayer(gradientLayer1, at: 0)
        fillSurveyView.setTitleColor(UIColor.white, for: .normal)
               
        getRecommendationView.layer.shadowColor = UIColor.black.cgColor
        getRecommendationView.layer.shadowOffset = CGSize(width: 0, height: 0)
        getRecommendationView.layer.shadowOpacity = 0.2
        getRecommendationView.layer.shadowRadius = 5.0
        getRecommendationView.layer.insertSublayer(gradientLayer2, at: 0)
        getRecommendationView.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getRespondents {
            DispatchQueue.main.async {
//                self.respondentsListTableView.reloadData()
            }
        }
    }
    
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
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0

        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
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

//    extension DinnerStatusViewController: CuisineSearchControllerDelegate{
//        func refreshTable() {
//            getRespondents {
//                DispatchQueue.main.async {
//                    self.respondentsListTableView.reloadData()
//                }
//            }
//        }
//    }
