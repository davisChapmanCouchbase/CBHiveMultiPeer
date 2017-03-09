//
//  NameEntryViewController.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 1/31/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation
import UIKit

class NameEntryViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    var parentView: ViewController? = nil
    //let isAdmin: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.nameTextField.delegate = self
        nameTextField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func setNameButtonTouched(_ sender: Any) {
        if (!(nameTextField.text?.isEmpty)!) {
            if (parentView != nil) {
                parentView?.setName(name: nameTextField.text!)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.setNodeName(name: nameTextField.text!)
                parentView?.startBrowseTimer()
            }
            dismiss(animated: true, completion: nil)
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (nameTextField.isFirstResponder) {
            self.setNameButtonTouched(self)
        }
        return false
    }
    
    func textFieldDidChange(_ textField: UITextField) {
    }
}
