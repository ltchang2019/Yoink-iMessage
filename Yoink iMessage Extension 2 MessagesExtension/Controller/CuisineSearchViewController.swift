//
//  CuisineSearchViewController.swift
//  Yoink iMessage Extension 2 MessagesExtension
//
//  Created by Luke Tchang on 2/16/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol CuisineSearchControllerDelegate{
    func dropNewPin(location: String)
}

class CuisineSearchViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mySearchTextField: UITextField!
    @IBOutlet weak var nextButtonView: UIView!
    @IBOutlet weak var priceButton1: UIButton!
    @IBOutlet weak var priceButton2: UIButton!
    @IBOutlet weak var priceButton3: UIButton!
    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var priceRangeTitleLabel: UILabel!
    var tableView: CustomTableView?
    
    var delegate: CuisineSearchControllerDelegate!
    
    var finalString: String!
    var personName: String!
    var dollarPreference: Int?
    var address: String?
    var chosenLocation: CLLocation?
    
    var completer = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
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
    
    
    override func viewDidLayoutSubviews() {
//        buildSearchTableView()
    }
    
    override func viewDidLoad() {
        preparePricingButtons()
        
        tableView?.delegate = self
        tableView?.dataSource = self
        completer.delegate = self as! MKLocalSearchCompleterDelegate
        
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
        if locationSearchBar.text != nil{
            delegate.dropNewPin(location: locationSearchBar.text!)
        }
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

//SEARCHBAR DELEGATE METHODS
extension CuisineSearchViewController: UISearchBarDelegate, MKLocalSearchCompleterDelegate{
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        buildSearchTableView()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchBarText = locationSearchBar.text {
            self.completer.queryFragment = searchBarText
        }
        print(completer.results)
        //update newly spawned table view
        tableView?.isHidden = false
        tableView?.reloadData()
        print("RELOADING TABLE")
    }
}

//SEARCHBAR TABLEVIEW METHODS
extension CuisineSearchViewController: UITableViewDelegate, UITableViewDataSource{
    
    func buildSearchTableView() {
        if let tableView = tableView {
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            self.locationSearchBar.window?.addSubview(tableView)
        } else {
            //addData()
            print("tableView created")
            tableView = CustomTableView(frame: CGRect.zero)
            tableView?.delegate = self
            tableView?.dataSource = self
            tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "CustomSearchTextFieldCell")
            self.locationSearchBar.window?.addSubview(tableView!)
        }
        updateSearchTableView()
    }
    
    func updateSearchTableView() {
        if let tableView = tableView {
            self.view.bringSubviewToFront(tableView)
            var tableHeight: CGFloat = 0
            tableHeight = tableView.contentSize.height
            
            // Set a bottom margin of 10p
            if tableHeight < tableView.contentSize.height {
                tableHeight -= 10
            }
            
            // Set tableView frame
//            var tableViewFrame = CGRect(x: 0, y: 0, width: tableView.frame.size.width - 4, height: tableHeight)
//            tableViewFrame.origin = tableView.convert(tableViewFrame.origin, to: nil)
//            tableViewFrame.origin.x += 2
//            tableViewFrame.origin.y += tableView.frame.size.height + 2
//            UIView.animate(withDuration: 0.2, animations: { [weak self] in
//                self?.tableView?.frame = tableViewFrame
//            })
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.topAnchor.constraint(equalTo: locationSearchBar.bottomAnchor).isActive = true
//            tableView.bottomAnchor.constraint(equalTo: priceRangeTitleLabel.bottomAnchor).isActive = true
            tableView.leftAnchor.constraint(equalTo: locationSearchBar.leftAnchor).isActive = true
            tableView.rightAnchor.constraint(equalTo: locationSearchBar.rightAnchor).isActive = true
            
            //Setting tableView style
            tableView.layer.masksToBounds = true
            tableView.separatorInset = UIEdgeInsets.zero
            tableView.layer.cornerRadius = 5.0
            tableView.separatorColor = UIColor.lightGray
            tableView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
            
            if self.isFirstResponder {
                self.view.bringSubviewToFront(tableView)
            }
            
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("number of sections")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows in section: \(self.completer.results.count)")
        return self.completer.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("creating cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomSearchTextFieldCell", for: indexPath) as UITableViewCell
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = "\(self.completer.results[indexPath.row].title), \(self.completer.results[indexPath.row].subtitle)"
        print("\(self.completer.results[indexPath.row].title), \(self.completer.results[indexPath.row].subtitle)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row")
        self.address = "\(self.completer.results[indexPath.row].title), \(self.completer.results[indexPath.row].subtitle)"
        tableView.isHidden = true
        locationSearchBar.text = self.address
    }
}

class CustomTableView: UITableView{
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        let height = min(contentSize.height, maxHeight)
        return CGSize(width: contentSize.width, height: height)
    }
}
