//
//  HiveManager.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 2/2/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public class HiveManager {
    public let database: CBLDatabase!
    public let peerBrowser: PeerBrowser
    public var nodes = [CBHNode]()
    
    private var peerNm: String?
    private var nbrOfNodes: String = "0"
    
    private var sharer: PeerListener? = nil
    
    public init(database: CBLDatabase) {
        self.database = database
        self.peerBrowser = PeerBrowser(serviceType: PeerListener.kServiceType)
        self.peerBrowser.parent = self
    }
    
    /** The visible name the app will publish, which will be visible to other users browsing peers.
     You should probably let the user pick this. The value is saved persistently. */
    public var peername: String? {
        get {
            return peerNm
        }
        set(newName) {
            if newName != peerNm {
                peerNm = newName
                let rootNode = CBHNode(name: newName!, url: "", uuid: "")
                rootNode.isOnline = true
                nodes.append(rootNode)
                peerBrowser.setPeeerName(peerName: newName!)
                if sharer != nil {
                    sharer?.stop()
                }
                do {
                    try sharer = PeerListener(database: database, peername: peerNm!)
                    try sharer?.start()
                    peerBrowser.startAdvertiser(uuid: (sharer?.peerUUID)!, url: (sharer?.url)!)
                } catch let error as NSError {
                    NSLog("Problem sharing the database %@", error)
                }
            }
        }
    }

    public func addNode(name: String, peerId: MCPeerID, url: String, uuid: String) {
        let newNode = CBHNode(name: name, url: url, uuid: uuid)
        newNode.peerId = peerId
        newNode.isOnline = true
        var found:Bool = false
        for curNode in nodes {
            if curNode.peerId == newNode.peerId {
                found = true
            }
        }
        if !found {
            newNode.db = self.database
            newNode.startReplication()
            nodes.append(newNode)
        }
    }
    
    public func markNodeOffline(peerId: MCPeerID) {
        for curNode in nodes {
            if curNode.peerId == peerId {
                curNode.isOnline = false
                curNode.stopReplication()
            }
        }
    }
}
