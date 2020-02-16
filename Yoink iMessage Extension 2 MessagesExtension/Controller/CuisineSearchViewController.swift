//
//  CuisineSearchViewController.swift
//  Yoink iMessage Extension 2 MessagesExtension
//
//  Created by Luke Tchang on 2/16/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit

class CuisineSearchViewController: UIViewController{
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mySearchTextField: UITextField!
    @IBOutlet weak var nextButtonView: UIView!
    
    var finalString: String!
    
    override func viewDidLoad() {
        mySearchTextField.delegate = self as! UITextFieldDelegate
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.toSurvey2(_:)))
        nextButtonView.addGestureRecognizer(tap1)
    }
    
    @objc func toSurvey2(_ sender: Any){
        finalString = mySearchTextField.text
        performSegue(withIdentifier: "toSurvey2", sender: finalString)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toSurvey2"){
            let survey2VC = segue.destination as! SurveyViewController
            survey2VC.sentCuisineAnswer = sender as? String
        }
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

extension CuisineSearchViewController: SurveyViewControllerDelegate{
    func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}
