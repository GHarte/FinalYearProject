//
//  ShoutViewController.swift
//  m8up
//
//  Created by Gareth Harte on 07/01/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit
let user = PFUser.currentUser()

class ShoutViewController: UIViewController {
    
    let userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var shoutSwitch: UISwitch!
    
    @IBOutlet weak var sendPushButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //load from NSUserDefaults
        if (userDefaults.objectForKey("shout") != nil){
            shoutSwitch.on = userDefaults.objectForKey("shout") as! Bool
        }
        
        //Set up view
        checkShoutSwitch()
        
    }
    
    func checkShoutSwitch() {
        if shoutSwitch.on == false {
            messageTextView.alpha = 0.1
            messageTextView.userInteractionEnabled = false
            sendPushButton.alpha = 0.1
            sendPushButton.userInteractionEnabled = false
            
            user["shoutEnabled"] = false
            
            user.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                if error != nil{
                    //ProgressHUD.showError("Network error")
                }
            }
            
            
        }
            
        else {
            messageTextView.alpha = 1
            messageTextView.userInteractionEnabled = true
            sendPushButton.alpha = 1
            sendPushButton.userInteractionEnabled = true
            
            user["shoutEnabled"] = true
            
            user.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                if error != nil{
                    //ProgressHUD.showError("Network error")
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendButtonPushed(sender: UIButton) {
        
        if messageTextView.text != "" {
            
            messageTextView.resignFirstResponder()
            
            var push = PFPush()
            
            ////            push.setChannel("Everyone")
            //            push.setMessage("\(messageTextView.text)")
            //            push.sendPushInBackgroundWithBlock( {
            //                (isSuccessful: Bool!, error: NSError!) -> Void in
            //
            //                var alert = UIAlertView(title: "Mass Push", message: "Your mass push, '\(self.messageTextView.text)'has been sent", delegate: self, cancelButtonTitle: "Ok")
            //                alert.show()
            //
            //            })
            
            var pushQuery:PFQuery = PFInstallation.query()
            pushQuery.whereKey("deviceType", equalTo: "ios")
            
            PFPush.sendPushMessageToQueryInBackground(pushQuery, withMessage: "\(messageTextView.text)", block: nil)
            
        }
        
    }
    
    
    @IBAction func shoutSwitchFlicked(sender: UISwitch) {
        
        checkShoutSwitch()
        userDefaults.setBool(shoutSwitch.on, forKey: "shout") //save switch state to persistant storage
        
    }
    
    
    
}



