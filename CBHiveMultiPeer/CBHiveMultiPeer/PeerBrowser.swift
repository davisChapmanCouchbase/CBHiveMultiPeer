//
//  PeerBrowser.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 2/2/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public class PeerBrowser: NSObject, MCNearbyServiceBrowserDelegate {
    public var peerId: MCPeerID?
    public var session: MCSession?
    public var browser: MCNearbyServiceBrowser?
    public var peerAdvertiser: PeerAdvertiser?
    
    public var parent: HiveManager?
    
    private let serviceType: String

    /** Initialize, given a service type to browse for. */
    public init(serviceType: String) {
        self.serviceType = serviceType
        super.init()
    }

    public func setPeeerName(peerName: String) {
        peerId = MCPeerID(displayName: peerName)
        if parent != nil {
            for curNode in (parent?.nodes)! {
                if curNode.nodeName == peerName {
                    curNode.peerId = peerId
                    curNode.isOnline = true
                }
            }
        }
        session = MCSession(peer: peerId!)
        browser = MCNearbyServiceBrowser(peer: peerId!, serviceType: serviceType)
        browser?.delegate = self
        browser?.startBrowsingForPeers()
    }

    public func startAdvertiser(uuid: String, url: String) {
        let discoveryInfo: [String:String] = [CBHNode.kPeerTypeLabel:CBHNode.kPeerType, CBHNode.kUUIDLabel:uuid, CBHNode.kUrlLabel:url]
        peerAdvertiser = PeerAdvertiser(peer: peerId!, serviceType: serviceType, discoveryInfo: discoveryInfo)
        peerAdvertiser?.start()
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser,
                 didNotStartBrowsingForPeers error: Error){
        print("PeerBrowser: Error browsing for service: \(error.localizedDescription)")

    }
    
    public func browser(_ browser: MCNearbyServiceBrowser,
                 foundPeer peerID: MCPeerID,
                 withDiscoveryInfo info: [String : String]?) {
        print("PeerBrowser: Found nearby peer: \(peerID)")
        if info?[CBHNode.kPeerTypeLabel] == CBHNode.kPeerType {
            print("PeerBrowser: Peer Type Matches!")
            parent?.addNode(name: peerID.displayName, peerId: peerID, url: (info?[CBHNode.kUrlLabel])!, uuid: (info?[CBHNode.kUUIDLabel])!)
        }
    }
    
    public func browser(_ browser: MCNearbyServiceBrowser,
                 lostPeer peerID: MCPeerID) {
        print("PeerBrowser: Lost nearby peer: \(peerID)")
        
    }
}
