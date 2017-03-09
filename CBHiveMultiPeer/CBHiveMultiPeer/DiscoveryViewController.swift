//
//  DiscoveryViewController.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 1/31/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation
import UIKit

class DiscoveryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var nodeTableView: UITableView!
    
    var timeToDisplay: Int = 10
    
    var userName: String = "Anonymous"
    var numberOfPeers: Int = -1
    var nodes = Array<CBHNode>()
    var peerDisplayCount: Int = 0
    
    var listener: CBLListener!
    var peerDisplayTimer: Timer? = nil
    var updateTimer:Timer? = nil
    
    var hiveMgr: HiveManager! = nil
    
    var peers = [CBHNode]()

    @IBAction func dismissButtonTouched(_ sender: Any) {
        updateTimer?.invalidate()
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = userName
        populateArray()
        nodeTableView.delegate = self
        nodeTableView.dataSource = self
        nodeTableView.reloadData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        hiveMgr = appDelegate.hiveMgr
        self.statusLabel.text = "Status: Browsing for nodes."
        
        self.updatePeers()
        
        updateTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.refreshPeers), userInfo: nil, repeats: true)
    }
    
    private func updatePeers() {
        let peerTmp = hiveMgr.nodes.sorted(by: {$0.nodeName < $1.nodeName})
        var peerPend = [CBHNode]()
        if (peerTmp.count > 0) {
            for curPeer in peerTmp {
                if (curPeer.isOnline) {
                    peerPend.append(curPeer)
                }
            }
        }
        self.peers = peerPend
    }
    
    func refreshPeers() {
        self.updatePeers()
        self.nodeTableView.reloadData()
    }
    
    func populateArray() {
//        let node1 = CBHNode(name: "Test 1", url: "URL 1")
//        nodes.append(node1)
//        let node2 = CBHNode(name: "Test 2", url: "URL 2")
//        nodes.append(node2)
//        let node3 = CBHNode(name: "Test 3", url: "URL 3")
//        nodes.append(node3)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.peers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DiscoveredNodeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DiscoveredNode")! as! DiscoveredNodeTableViewCell
        cell.nodeLabel.text = peers[indexPath.row].nodeName
        if peers[indexPath.row].isOnline {
            cell.offlineLabel.isHidden = true
        } else {
            cell.offlineLabel.isHidden = false
        }
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
