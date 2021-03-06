//
//  ViewController.swift
//  m8up
//
//  Created by Gareth Harte on 04/12/2014.
//  Copyright (c) 2014 m8up. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //LoginViewController. Can't refactor swift to rename this class..
    
    @IBOutlet weak var loginCancelledLabel: UILabel!
    
    @IBAction func signInButton(sender: UIButton) {
        
        self.loginCancelledLabel.alpha = 0
        
        // ****make user of user_about_me to save the user some time. //
        
        PFFacebookUtils.logInWithPermissions(["public_profile", "user_about_me", "user_birthday"], block: {
            user, error in
            
            if user == nil {
                println("Uh oh. user cancelled fb login")
                
                //Add UIAlertController before pushing to app store
                
                return
            }
            else if user.isNew {
                println("User signed up and logged in through fb")
                
                FBRequestConnection.startWithGraphPath("/me?fields=picture,first_name,birthday,gender", completionHandler: {
                    connection, result, error in
                    var r = result as! NSDictionary
                    user["firstname"] = r["first_name"]
                    user["gender"] = r["gender"]
                    
                    //let dateFormatter = NSDateFormatter()
                    //dateFormatter.dateFormat = "MM/dd/yyyy"
                    
                    //causing the app to crash if facebook birthday is hidden. Need to get user's age differently.
                    //user["birthday"] = dateFormatter.dateFromString(r["birthday"] as! String)
                    
                    self.getCurrentLocation()
                    
                    let pictureURL = ((r["picture"] as! NSDictionary)["data"] as! NSDictionary) ["url"] as! String // revise
                    let url = NSURL(string: pictureURL)
                    let request = NSURLRequest(URL: url!)
                    NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                        response, data, error in
                        
                        let imageFile = PFFile(name: "avatar.jpg", data: data)
                        user["image"] = imageFile
                        user.saveInBackgroundWithBlock(nil)
                    })
                    
                })
                
                //make use of signupVC here instead?
                let appDelegate: AppDelegate = (UIApplication.sharedApplication()).delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = ((UIStoryboard(name: "Main", bundle: NSBundle .mainBundle()).instantiateInitialViewController()) as! UIViewController)
                
            }
            else { //if user is logged in, send them to the first page on the tab view controller
                println("user logged in through fb")
                
                self.getCurrentLocation()
                
                user.saveInBackgroundWithBlock(nil)
                
                let appDelegate: AppDelegate = (UIApplication.sharedApplication()).delegate as! AppDelegate
                
                appDelegate.window?.rootViewController = ((UIStoryboard(name: "Main", bundle: NSBundle .mainBundle()).instantiateInitialViewController()) as! UIViewController)
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    func getCurrentLocation() {
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error == nil {
                println(geoPoint)
                user["location"] = geoPoint
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

