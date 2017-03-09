//
//  ViewController.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 1/31/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var messagesTableView: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var screenNavItem: UINavigationItem!

    var database: CBLDatabase!
    var query: CBLLiveQuery!

    var messages = Array<CBHMessage>()

    var userName: String = "Anonymous"
    var rows = Array<CBLQueryRow>()

    func useDatabase(database: CBLDatabase!) -> Bool {
        guard database != nil else {
            return false
        }
        self.database = database
        
        // Define a view with a map function that indexes to-do items by creation date:
        database.viewNamed("peerMsgs").setMapBlock({
            (doc, emit) in
            if let type:String = doc["type"] as! String?, let id = doc["_id"], type == "peerMessage" {
                emit(id, doc)
            }
        }, reduce: nil, version: "1")
        
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        populateMessages()
        messagesTableView.reloadData()
        screenNavItem.title = userName
        let button = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(ViewController.addMessage))
        screenNavItem.rightBarButtonItem = button
        let button2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: #selector (ViewController.browseForPeers))
        screenNavItem.leftBarButtonItem = button2
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Database-related initialization:
        if useDatabase(database: appDelegate.database) {
            // Create a query sorted by descending date, i.e. newest items first:
            query = database.viewNamed("peerMsgs").createQuery().asLive()
            query.addObserver(self, forKeyPath: "rows", options: .new, context: nil)
            query.start()
            
            let rowEnum = query.rows
            let rowCount = rowEnum?.count
            while let curRow = rowEnum?.nextRow() {
                rows.append(curRow)
            }
        }

        if (userName == "Anonymous") {
            _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.getName), userInfo: nil, repeats: false);
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addMessage() {
        performSegue(withIdentifier: "AddMessage", sender: nil)
    }
    
    func populateMessages() {
//        let msg1 = CBHMessage(from: userName, msg: "Self generated message - This is a long message that should cover the width of the screen.")
//        messages.append(msg1)
//        let msg2 = CBHMessage(from: "Node 1", msg: "Node 1 generated message")
//        messages.append(msg2)
//        let msg3 = CBHMessage(from: "Node 2", msg: "Node 2 generated message")
//        messages.append(msg3)
//        let msg4 = CBHMessage(from: "Node 3", msg: "Node 3 generated message")
//        messages.append(msg4)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as? NSObject == query {
            messagesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if query != nil {
            if query.rows != nil {
                return Int(query.rows!.count)
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MessageTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MessageCell")! as! MessageTableViewCell
        if let document = query.rows?.row(at: UInt(indexPath.row)) {
            cell.fromLabel.text = "Received from : " + (document.document?["from"] as? String)!
            cell.messageLabel.text = document.document?["message"] as? String
        }
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        let viewFrame = self.view.frame
        var tableFrame = self.messagesTableView.frame
        tableFrame.size.width = viewFrame.size.width - 16
        self.messagesTableView.frame = tableFrame
    }
    
    func startBrowseTimer() {
        
        _ = Timer.scheduledTimer(timeInterval: 0.4, target: self, selector: #selector(self.browseForPeers), userInfo: nil, repeats: false)
    }

    func getName() {
        performSegue(withIdentifier: "GetName", sender: nil)
        
    }
    
    func browseForPeers() {
        performSegue(withIdentifier: "ViewNodes", sender: nil)
    }
    
    func setName(name: String) {
        self.userName = name
        screenNavItem.title = userName
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Device = UIDevice.current
        let iosVersion = NSString(string: Device.systemVersion).doubleValue
        let iOS8 = iosVersion >= 8
        let iOS7 = iosVersion >= 7 && iosVersion < 8
        
        if segue.identifier == "AddMessage" {
        } else if segue.identifier == "ViewNodes" {
        } else if segue.identifier == "GetName" {
            if (iOS8) {
                
            } else {
                self.navigationController?.modalPresentationStyle = UIModalPresentationStyle.currentContext
            }
            let controller = segue.destination as! NameEntryViewController
            controller.parentView = self
        }
    }
}

