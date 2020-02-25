//
//  CuisineSearchViewController.swift
//  Yoink iMessage Extension 2 MessagesExtension
//
//  Created by Luke Tchang on 2/16/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit
import MapKit
import LocationPicker
import CoreLocation

protocol CuisineSearchControllerDelegate {
    func dropNewPin()
}

class CuisineSearchViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mySearchTextField: UITextField!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var priceButton1: UIButton!
    @IBOutlet weak var priceButton2: UIButton!
    @IBOutlet weak var priceButton3: UIButton!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    var finalString: String!
    var personName: String!
    var delegate: CuisineSearchControllerDelegate!
    var dollarPreference: Int?
    var address: String?
    
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()
    var currentLocation: CLLocation!{
        didSet{
            geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
                if error == nil{
                    self.address = "\(placemarks![0].thoroughfare!), \(placemarks![0].locality!)"
                    self.locationSearchBar.text = self.address
                } else {
                    print(error)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        preparePricingButtons()
        
        nextButtonView.layer.cornerRadius = 10
        nextButtonView.layer.masksToBounds = true
        mySearchTextField.delegate = self as! UITextFieldDelegate
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.submitPreferences(_:)))
        nextButtonView.addGestureRecognizer(tap1)
    }
    
    func preparePricingButtons(){
        priceButton1.layer.borderWidth = 1
        priceButton2.layer.borderWidth = 1
        priceButton3.layer.borderWidth = 1
        
        priceButton1.layer.cornerRadius = 5
        priceButton2.layer.cornerRadius = 5
        priceButton3.layer.cornerRadius = 5
        
        priceButton1.layer.borderColor = UIColor.lightGray.cgColor
        priceButton2.layer.borderColor = UIColor.lightGray.cgColor
        priceButton3.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @IBAction func useCurrentLocationPressed(_ sender: Any) {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            currentLocation = location
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    @IBAction func button1Pressed(_ sender: Any) {
        dollarPreference = 1
        priceButton1.setTitleColor(UIColor.white, for: .normal)
        priceButton2.setTitleColor(UIColor.lightGray, for: .normal)
        priceButton3.setTitleColor(UIColor.lightGray, for: .normal)
        priceButton1.layer.backgroundColor = UIColor.systemTeal.cgColor
        priceButton2.layer.backgroundColor = UIColor.clear.cgColor
        priceButton3.layer.backgroundColor = UIColor.clear.cgColor
    }
    @IBAction func button2Pressed(_ sender: Any) {
        dollarPreference = 2
        priceButton1.setTitleColor(UIColor.lightGray, for: .normal)
        priceButton2.setTitleColor(UIColor.white, for: .normal)
        priceButton3.setTitleColor(UIColor.lightGray, for: .normal)
        priceButton1.layer.backgroundColor = UIColor.clear.cgColor
        priceButton2.layer.backgroundColor = UIColor.systemTeal.cgColor
        priceButton3.layer.backgroundColor = UIColor.clear.cgColor
    }
    @IBAction func button3Pressed(_ sender: Any) {
        dollarPreference = 3
        priceButton1.setTitleColor(UIColor.lightGray, for: .normal)
        priceButton2.setTitleColor(UIColor.lightGray, for: .normal)
        priceButton3.setTitleColor(UIColor.white, for: .normal)
        priceButton1.layer.backgroundColor = UIColor.clear.cgColor
        priceButton2.layer.backgroundColor = UIColor.clear.cgColor
        priceButton3.layer.backgroundColor = UIColor.systemTeal.cgColor
    }
    
    @objc func submitPreferences(_ sender: Any){
        //submit cuisine and price to database (final string + dollarPreference)
        self.dismiss(animated: true, completion: nil)
    }
    
    let suggestions = [
        "Burmese",
        "Cambodian",
        "Filipino",
        "Bruneian",
        "Indonesian",
        "Laotian",
        "Malaysian",
        "Singaporean",
        "Thai",
        "Vietnamese",
        "Chinese",
        "Cantonese",
        "Japanese",
        "Korean",
        "Mongolian",
        "Taiwanese",
        "Dim Sum",
        "Rice",
        "Tea",
        "Arabian",
        "Assyrian",
        "Bahraini",
        "Emirati",
        "Iranian",
        "Iraqi",
        "Kuwaiti",
        "Qatari",
        "Saudi Arabian",
        "Turkish",
        "Yemeni",
        "Israeli",
        "Jordanian",
        "Lebanese",
        "Syrian",
        "Armenian",
        "Georgian",
        "Afghan",
        "Bangladeshi",
        "Bhutanese",
        "Indian",
        "Pakistani",
        "Kashmiri",
        "Cafe",
        "Finnish",
        "Danish",
        "Swedish",
        "Lithuanian",
        "Estonian",
        "Latvian",
        "Croatian",
        "Bulgarian",
        "Slovenian",
        "Irish",
        "British",
        "Fish and chips",
        "French",
        "Bakery",
        "Spanish",
        "Hungarian",
        "Romanian",
        "Polish",
        "Dutch",
        "German",
        "Belgian",
        "Austrian",
        "Greek",
        "Portugese",
        "Italian",
        "Costa Rican",
        "Cuban",
        "Guatemalan",
        "Haitian",
        "Honduran",
        "Jamaican",
        "Mexican",
        "Nicaraguan",
        "Panamanian",
        "Puerto Rican",
        "Trinidadian and Tobagonian",
        "American",
        "Hamburger",
        "Fast food",
        "Ice cream",
        "Fried chicken",
        "Steak",
        "Sandwich",
        "Pizza"
    ]
   
    
}

extension CuisineSearchViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     return !autoCompleteText( in : textField, using: string, suggestions: suggestions)
    }
    
    func autoCompleteText( in textField: UITextField, using string: String, suggestions: [String]) -> Bool {
     if !string.isEmpty,
      let selectedTextRange = textField.selectedTextRange,
       selectedTextRange.end == textField.endOfDocument,
       let prefixRange = textField.textRange(from: textField.beginningOfDocument, to: selectedTextRange.start),
        let text = textField.text( in : prefixRange) {
         let prefix = text + string
        let matches = suggestions.filter{
          $0.hasPrefix(prefix)
         }
         if (matches.count > 0) {
          textField.text = matches[0]
          if let start = textField.position(from: textField.beginningOfDocument, offset: prefix.count) {
            textField.selectedTextRange = textField.textRange(from: start, to: textField.endOfDocument); return true
          }
         }
        }
     return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
    }
}

extension CuisineSearchViewController: UISearchBarDelegate{
    
}
