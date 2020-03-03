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

class DinnerStatusViewController: UIViewController{
    
    @IBOutlet weak var respondentsListTableView: UITableView!
    @IBOutlet weak var fillSurveyView: UIButton!
    @IBOutlet weak var getRecommendationView: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonsView: UIView!
    
    var respondentsList: [String] = []
    var delegate: DinnerStatusDelegate!
    var fpc: FloatingPanelController!
    
    let geocoder = CLGeocoder()
    var locationStringArray: [String] = ["Wilbur Dining, 658 Escondido Rd, Stanford, CA 94305", "Stern Hall, 618 Escondido Rd, Stanford, CA 94305"]
    var annotationsArray: [MKPointAnnotation]?
    
    override func viewDidLoad() {
        mapView.delegate = self
        mapView.register(LocationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        addAnnotations()
        adjustMapRegion()
        setUpFloatingPanel()
        
//        respondentsListTableView.dataSource = self
//        respondentsListTableView.delegate = self as! UITableViewDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fillSurveyView.layer.cornerRadius = 10
        getRecommendationView.layer.cornerRadius = 10
    }
    
    func addAnnotations(){
        for x in 0...locationStringArray.count - 1{
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(self.locationStringArray[x]) { (placemarks, error) in
                guard let placemarks = placemarks, let pinLocation = placemarks.first?.location
                else {
                    print("Error geocoding address")
                    return
                }
                let lat = pinLocation.coordinate.latitude
                let long = pinLocation.coordinate.longitude
                                    
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                annotation.title = placemarks[0].thoroughfare
                annotation.subtitle = placemarks[0].locality
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func adjustMapRegion(){
        let location = CLLocationCoordinate2D(latitude: 37.423893,
        longitude: -122.163170)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
    }
    
    func setUpFloatingPanel(){
        fpc = FloatingPanelController()
        fpc.delegate = self as FloatingPanelControllerDelegate
        let contentVC = storyboard?.instantiateViewController(identifier: "FloatingPanelVC") as! FloatingPanelViewController
        contentVC.delegate = self
        
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        getRespondents {
            DispatchQueue.main.async {
//                self.respondentsListTableView.reloadData()
            }
        }
    }
    
//    @objc func getRecommendation(_ sender: Any) {
//            print("Get Recommendation Pressed")
//            getRec { (name, similarity) in
//                print(name, similarity)
//                self.delegate.sendRecMessage(restaurantName: name, similarity: similarity)
//            }
//    }
    
    func getColorByHex(rgbHexValue:UInt32, alpha:Double = 1.0) -> UIColor {
        let red = Double((rgbHexValue & 0xFF0000) >> 16) / 256.0
        let green = Double((rgbHexValue & 0xFF00) >> 8) / 256.0
        let blue = Double((rgbHexValue & 0xFF)) / 256.0

        return UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
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

extension DinnerStatusViewController: FloatingPanelControllerDelegate{
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return CustomFloatingPanelLayout()
    }
}

class CustomFloatingPanelLayout: FloatingPanelLayout {
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
            case .full: return 16.0 // A top inset from safe area
            case .half: return 216.0 // A bottom inset from the safe area
            case .tip: return 150.0 // A bottom inset from the safe area
            default: return nil // Or `case .hidden: return nil`
        }
    }
    
    public var initialPosition: FloatingPanelPosition{
        return .tip
    }
}

extension DinnerStatusViewController: FloatingPanelViewControllerDelegate{
    func sendInfoToMessageController(restaurantName: String, similarity: Double) {
        delegate.sendRecMessage(restaurantName: restaurantName, similarity: similarity)
    }
}

extension DinnerStatusViewController: CuisineSearchControllerDelegate{
    func dropNewPin() {
    }
}

extension DinnerStatusViewController: MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseIdentifier") as? MKMarkerAnnotationView
            if view == nil {
                view = MKMarkerAnnotationView(annotation: nil, reuseIdentifier: "reuseIdentifier")
            }
            view?.annotation = annotation
            view?.displayPriority = .required
            return view
        }
}


class LocationView: MKAnnotationView{
    override var annotation: MKAnnotation? {
        willSet {
            if let _ = newValue as? CLLocationCoordinate2D {
                self.displayPriority = .required
            }
        }
    }
}
