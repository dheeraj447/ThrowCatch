//
//  SharedObject.swift
//  ThrowCatch
//
//  Created by Kaveti, Dheeraj on 12/26/16.
//  Copyright © 2016 DPSG. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FBSDKLoginKit

class SharedObject: NSObject {
    static var selfInstance: SharedObject!
    var currentUser: User!
    
    class func sharedInstance() -> SharedObject {
        if (selfInstance == nil) {
            selfInstance = SharedObject()
        }
        return selfInstance
    }
    
    func checkIfUserExists(emailId: String, completionHandler: @escaping (Bool) -> ()) {
        DataService.ds.USER_DB_REF.queryOrdered(byChild: "email").queryEqual(toValue: emailId).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? [String: AnyObject] {
                        // let party = Party(partyId: snap.key, msgData: postDict) // Message(msgId: snap.key, msgData: postDict)
                        let user = User(msgData: postDict)
                        SharedObject.sharedInstance().currentUser = user
                        completionHandler(true)
                        break
                        // self.msgs.insert(message, at: 0)
                    }
                }
                completionHandler(false)
            }
        })
        
    }
    
    func checkIfUserExists(userId: String, completionHandler: @escaping (Bool) -> ()) {
        DataService.ds.USER_DB_REF.queryOrdered(byChild: "userId").queryEqual(toValue: userId).observe(.value, with: { (snapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
                for snap in snapshot {
                    if let postDict = snap.value as? [String: AnyObject] {
                        // let party = Party(partyId: snap.key, msgData: postDict) // Message(msgId: snap.key, msgData: postDict)
                        let user = User(msgData: postDict)
                        SharedObject.sharedInstance().currentUser = user
                        completionHandler(true)
                        break
                        // self.msgs.insert(message, at: 0)
                    }
                }
                completionHandler(false)
            }
        })
        
    }
    
}
