//
//  User.swift
//  m8up
//
//  Created by Gareth Harte on 25/04/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import Foundation

var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()

struct User {
    let id: String
    let name: String
    let currentLocation: PFGeoPoint
    private let pfUser: PFUser
    
    func getPhoto(callback:(UIImage) -> ()) { //Done asynchronously - nested functions
        let imageFile = pfUser.objectForKey("image") as! PFFile
        imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if let data = data {
                callback(UIImage(data: data)!)
            }
        }
    }
    
}

func pfUserToUser(user: PFUser) -> User {
    
    return User(id: user.objectId, name: user.objectForKey("firstname") as! String, currentLocation: user.objectForKey("location") as! PFGeoPoint, pfUser: user)
    
}

func currentUser() -> User? {
    
    if let user = PFUser.currentUser() {
        return pfUserToUser(user)
    }
    return nil
    
}

func fetchUnviewedUsers(callback: ([User]) -> ()) {
    
    var q = PFQuery(className: "Action")
    q.whereKey("byUser", equalTo: PFUser.currentUser().objectId)
    q.findObjectsInBackgroundWithBlock({
        objects, error in
        
        let seenIDs = map( (objects as! [PFObject]), {$0.objectForKey("toUser")!})
        
        var query = PFUser.query()
        query.whereKey("objectId", notEqualTo: PFUser.currentUser().objectId)
        query.whereKey("objectId", notContainedIn: seenIDs)
        
        //location test - default if NSUserDefaults not set
        query.whereKey("location", nearGeoPoint: PFUser.currentUser().objectForKey("location") as! PFGeoPoint, withinKilometers: 5)
        
        if let locationPref: AnyObject = userDefaults.objectForKey("dist") {
            query.whereKey("location", nearGeoPoint: PFUser.currentUser().objectForKey("location") as! PFGeoPoint, withinKilometers: locationPref.doubleValue)
        }
        
        else {
            //location test - default if NSUserDefaults not set
            query.whereKey("location", nearGeoPoint: PFUser.currentUser().objectForKey("location") as! PFGeoPoint, withinKilometers: 5)
        }
        
        query.findObjectsInBackgroundWithBlock({
            objects, error in
            if let pfUsers = objects as? [PFUser]{
                let users = map(pfUsers, {pfUserToUser($0)})
                callback(users)
            }
        })
        
    })
    
}

func saveSkip(user: User) {
    
    let skip = PFObject(className: "Action")
    skip.setObject(PFUser.currentUser().objectId, forKey: "byUser")
    skip.setObject(user.id, forKey: "toUser")
    skip.setObject("skipped", forKey: "type")
    skip.saveInBackgroundWithBlock(nil)
    
}

func saveLike(user: User) {
    
    var q = PFQuery(className: "Action")
    q.whereKey("byUser", equalTo: user.id)
    q.whereKey("toUser", equalTo: PFUser.currentUser().objectId)
    q.whereKey("type", equalTo: "liked")
    q.getFirstObjectInBackgroundWithBlock({
        object, error in
        
        //create a unique chatroom (matchId)
        let matchId = PFUser.currentUser()!.objectId! + "-" + user.id
        
        var matched = false
        
        if object != nil {
            matched = true
            object.setObject("matched", forKey: "type")
            
            //test
            object.setObject(matchId, forKey: "matchId")
            object.saveInBackgroundWithBlock(nil)
            
        }
        
        let match = PFObject(className: "Action")
        match.setObject(PFUser.currentUser().objectId, forKey: "byUser")
        match.setObject(user.id, forKey: "toUser")
        
        if matched {
            match.setObject("matched", forKey: "type")
            match.setObject(matchId, forKey: "matchId")
        }
        else {
            match.setObject("liked", forKey: "type")
        }
        
        match.saveInBackgroundWithBlock(nil)
        
    })
    
    
}

