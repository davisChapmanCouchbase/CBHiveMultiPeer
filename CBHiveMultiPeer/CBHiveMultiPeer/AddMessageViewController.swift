//
//  AddMessageViewController.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 1/31/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation
import UIKit

class AddMessageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.messageTextField.delegate = self
        messageTextField.becomeFirstResponder()
    }

    @IBAction func cancelButtonTouched(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTouched(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let createDate = CBLJSON.jsonObject(with: Date())
        let properties: [String : AnyObject] = [
            "type": "peerMessage" as AnyObject,
            "message": messageTextField.text as AnyObject,
            "from": appDelegate.hiveMgr.peername as AnyObject,
            "created_at": createDate as AnyObject]
        let docId = "peerMessage::" + appDelegate.hiveMgr.peername! + "::" + NSUUID().uuidString
        
        // Save the document:
        do {
            guard let doc = appDelegate.database.document(withID: docId) else {
                appDelegate.showAlert(message: "Couldn't create message", forError: nil)
                return
            }
            do {
                try doc.putProperties(properties)
            } catch let error as NSError {
                appDelegate.showAlert(message: "Couldn't save message", forError: error)
            }
            var docIds: [String] = []
            docIds.append(docId)
        } catch let error as NSError {
            appDelegate.showAlert(message: "Couldn't save new item", forError: error)
        }
        dismiss(animated: true, completion: nil)
    }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            messageTextField.resignFirstResponder()
            self.saveButtonTouched(self)
            return false
        }
}
