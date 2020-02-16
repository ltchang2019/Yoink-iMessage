//
//  MessagesViewController.swift
//  Yoink iMessage Extension 2 MessagesExtension
//
//  Created by Luke Tchang on 2/15/20.
//  Copyright © 2020 Luke Tchang. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController {
    
    @IBAction func expandButtonPressed(_ sender: Any){
        if let conversation = activeConversation {
            let layout = MSMessageTemplateLayout()
            layout.caption = "Stepper Value"
            
            let message = MSMessage()
            message.layout = layout
            message.url = URL(string: "yoink.com/fillform")
            conversation.insert(message, completionHandler: { (error: Error?) in
                print(error)
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(activeConversation?.selectedMessage?.url?.absoluteString == nil){
            
        } else {
            requestPresentationStyle(.expanded)
            let storyboard = UIStoryboard(name: "MainInterface", bundle: nil)
            let dinnerStatusVC = storyboard.instantiateViewController(identifier: "DinnerStatusVC") as! DinnerStatusViewController
            dinnerStatusVC.delegate = self
            show(dinnerStatusVC, sender: self)
        }
    }
        
}


extension MessagesViewController: DinnerStatusDelegate{
    func sendRecMessage(restaurantName: String, similarity: Double) {
        print("MESSAGE SENDING")
        if let conversation = activeConversation {
            conversation.insertText("Restaurant Name: \(restaurantName), Similarity: \(similarity)") { (error: Error?) in
                print(error)
                self.dismiss()
            }
        }
    }
}

    
    // MARK: - Conversation Handling
extension MessagesViewController{
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dissmises the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called before the extension transitions to a new presentation style.
    
        // Use this method to prepare for the change in presentation style.
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}
