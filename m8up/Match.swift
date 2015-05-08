//
//  Match.swift
//  m8up
//
//  Created by Gareth Harte on 02/05/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import Foundation

struct Match {
    let id: String
    let user: User
}

func fetchMatches (callBack: ([Match]) -> ()) {
    
    let q = PFQuery(className: "Action")
    q.whereKey("byUser", equalTo: PFUser.currentUser().objectId)
    q.whereKey("type", equalTo: "matched")
    q.findObjectsInBackgroundWithBlock({
        objects, error in
        
        if let matches = objects as? [PFObject] {
            let matchedUsers = matches.map({
                (object) -> (matchID: String, userID: String)
                in
//                (object.objectId, object.objectForKey("toUser") as! String)
                (object.objectForKey("matchId") as! String, object.objectForKey("toUser") as! String)
            })
            let userIDs = matchedUsers.map({$0.userID})
            
            let q2 = PFUser.query()
            q2.whereKey("objectId", containedIn: userIDs)
            q2.findObjectsInBackgroundWithBlock({
                objects, error in
                
                if let users = objects as? [PFUser] {
                    var users = reverse(users)
                    var m = Array<Match>()
                    for (index, user) in enumerate(users) {
                        m.append(Match(id: matchedUsers[index].matchID, user: pfUserToUser(user)))
                    }
                    callBack(m)
                }
            })
            
        }
        
        
    })
    
}