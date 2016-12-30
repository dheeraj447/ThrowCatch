//
//  Message.swift
//  firebase-sort-data
//
//  Created by Jess Rascal on 06/08/2016.
//  Copyright © 2016 Jess Rascal. All rights reserved.
//

import Foundation

class Party {
    var partyId: String!
    var partyname: String!
    var place: String!
    var partyDate: String!
    
    init(partyId: String, msgData: [String: AnyObject]) {
        self.partyId = partyId
        
        if let partyname = msgData["partyname"] as? String {
            self.partyname = partyname
        }
        
        if let place = msgData["place"] as? String {
            self.place = place
        }
        
        if let partyDate = msgData["date"] as? String {
            self.partyDate = partyDate
        }
    }
}

class User {
    var userId: String!
    var emailId: String!
    var firstName: String!
    var lastName: String!
    var throwingParties: [String]!
    var catchingParties: [String]!
    
    init(msgData: [String: AnyObject]) {
        
        if let userId = msgData["userId"] as? String {
            self.userId = userId
        }
        
        if let firstName = msgData["firstName"] as? String {
            self.firstName = firstName
        }
        
        if let lastName = msgData["lastName"] as? String {
            self.lastName = lastName
        }
        
        if let emailId = msgData["email"] as? String {
            self.emailId = emailId
        }
    }
    
    init(userId: String, firstName: String, lastName: String, emailId: String) {
        self.userId = userId
        
        self.firstName = firstName
        
        self.lastName = lastName
        
        self.emailId = emailId
    }
}
