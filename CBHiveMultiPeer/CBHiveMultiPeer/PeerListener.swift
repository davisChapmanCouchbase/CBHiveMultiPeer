//
//  PeerListener.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 2/2/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation

public class PeerListener {
    
    public static let kDefaultPort: UInt16 = 0 //59844
    
    /** Bonjour service type for publishing a database */
    public static let kServiceType = "cb-peersync"
    
    /** The UUID I publish as */
    public let peerUUID: String
    public var url: String = ""
    
    private let ssl : Bool
    
    private let db: CBLDatabase
    private let listener: CBLListener
    
    public init(database: CBLDatabase, peername: String, port: UInt16 = kDefaultPort, ssl: Bool = true) throws {
        // Get or create a persistent UUID:
        
        // Create the CBL listener:
        db = database
        listener = CBLListener(manager: db.manager, port: port)
        
        self.ssl = ssl
        if ssl {
            do {
                try listener.setAnonymousSSLIdentityWithLabel("peersync")
            } catch {
                assert(false, "Unable to get SSL identity");
            }
        }
        
        if let certDigest = listener.sslIdentityDigest {
            // Use SHA-1 digest of my SSL cert as my UUID:
            peerUUID = certDigest.base64EncodedString()
        } else if let uuid = UserDefaults.standard.string(forKey: "PeerUUID") {
            peerUUID = uuid
        } else {
            // If not using SSL, just make up a persistent UUID:
            peerUUID = NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
            UserDefaults.standard.set(peerUUID, forKey: "PeerUUID")
        }
        
        listener.requiresAuth = false
        
        print("PeerListener: My UUID is '\(peerUUID)'")
        print("PeerListener: Sharing at <\(listener.url)>")
        
    }
    
    /** Starts sharing. */
    public func start() throws {
        try listener.start()
        print("PeerListener: Sharing database...");
        print("PeerListener: Sharing at <\(listener.url?.absoluteString)>")
        self.url = (listener.url?.absoluteString)!
        let txt = ["url": listener.url?.absoluteString]
        listener.txtRecordDictionary = txt
    }
    
    /** Pauses sharing. */
    public func stop() {
        listener.stop()
        print("PeerListener: ...Stopped sharing database");
    }
    
    deinit {
        listener.stop()
    }
}
