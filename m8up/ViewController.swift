//
//  ViewController.swift
//  m8up
//
//  Created by Gareth Harte on 04/12/2014.
//  Copyright (c) 2014 m8up. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginCancelledLabel: UILabel!
    
    @IBAction func signInButton(sender: UIButton) {
        
        var permissions = ["public_profile"]
        
        self.loginCancelledLabel.alpha = 0
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
                self.loginCancelledLabel.alpha = 1
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
                self.performSegueWithIdentifier("signUp", sender: self)
            } else {
                NSLog("User logged in through Facebook!")
                
                let appDelegate: AppDelegate = (UIApplication.sharedApplication()).delegate as AppDelegate
                
                appDelegate.window?.rootViewController = ((UIStoryboard(name: "Main", bundle: NSBundle .mainBundle()).instantiateInitialViewController()) as UIViewController)
                
            }
            
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

