//
//  CBHMessage.swift
//  CBHiveMultiPeer
//
//  Created by Davis Chapman on 2/1/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation

class CBHMessage {
    var msgFrom : String = ""
    var msgMessage : String = ""
    
    init(from : String, msg : String) {
        self.msgFrom = from
        self.msgMessage = msg
    }
}
