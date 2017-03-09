//
//  PeerAdvertiser.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 2/2/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation
import MultipeerConnectivity

public class PeerAdvertiser : NSObject, MCNearbyServiceAdvertiserDelegate {
    public var svcAdvertiser: MCNearbyServiceAdvertiser!
    
    public init(peer: MCPeerID, serviceType: String, discoveryInfo: [String:String]?) {
        svcAdvertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: discoveryInfo, serviceType: serviceType)
        super.init()
        svcAdvertiser.delegate = self
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                             didNotStartAdvertisingPeer error: Error){
        print("PeerAdvertiser: Error advertising service: \(error.localizedDescription)")
    }
    
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                    didReceiveInvitationFromPeer peerID: MCPeerID,
                    withContext context: Data?,
                    invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
    
    public func start() {
        svcAdvertiser.startAdvertisingPeer()
    }
    
    public func stop() {
        svcAdvertiser.stopAdvertisingPeer()
    }
}
