//
//  CBHNode.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 2/1/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public class CBHNode : NSObject, NetServiceDelegate {
    public static let kPeerTypeLabel = "appType"
    public static let kPeerType = "hiveDemo"
    public static let kUUIDLabel = "UUID"
    public static let kUrlLabel = "URL"
    public static let kDelimiter = " | "
    
    public var nodeName : String = ""
    public var nodeUrl : String = ""
    public var peerType : String = ""
    public var nbrOfNodes : String = ""
    public var isOnline: Bool = false
    public var peerUuid : String = ""
    
    /** Unique ID of this peer */
    public var peerId: MCPeerID?
    
    public var next: CBHNode?
    public var prev: CBHNode?

    public var db: CBLDatabase?
    public var replicator: CBLReplication?
    
    init(name : String, url : String, uuid: String) {
        self.nodeName = name
        self.nodeUrl = url
        self.peerUuid = uuid
    }
    
    public func addNode(node: CBHNode) {
        if next == nil {
            next = node
            node.prev = self
        } else {
            next?.addNode(node: node)
        }
    }
    
    public func startReplication() {
        if db != nil {
            let repUrl = NSURL(string: nodeUrl + (db?.name)!)
            let push = self.db?.createPushReplication(repUrl as! URL)
            //if ssl {
                // Peer's UUID is the SHA-1 digest of its SSL cert, so pin to that:
                let cert = NSData(base64Encoded: peerUuid)
                push?.customProperties = ["pinnedCert": cert!]
            push?.continuous = true
            //}
            print("\(self): Pushing to <\(repUrl)> for UUID \(peerUuid)")
            self.replicator = push
            push?.start()
            
        }
    }
    
    public func stopReplication() {
        if replicator != nil {
            replicator?.stop()
            replicator = nil
        }
    }
}
