//
//  ShoutViewController.swift
//  m8up
//
//  Created by Gareth Harte on 07/01/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit

class ShoutViewController: UIViewController {
    
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var shoutSwitch: UISwitch!
    
    @IBOutlet weak var sendPushButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPushed(sender: UIButton) {
        
        if messageTextView.text != "" {
            
            messageTextView.resignFirstResponder()
            
            var push = PFPush()
            
            push.setChannel("Everyone")
            push.setMessage("\(messageTextView.text)")
            push.sendPushInBackgroundWithBlock( {
                (isSuccessful: Bool!, error: NSError!) -> Void in
                
                var alert = UIAlertView(title: "Mass Push", message: "Your mass push, '\(self.messageTextView.text)'has been sent", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
                
            })
        }
        
    }
    
    
    @IBAction func shoutSwitchFlicked(sender: UISwitch) {
        
        if shoutSwitch.on == false {
            messageTextView.alpha = 0.1
            messageTextView.userInteractionEnabled = false
            sendPushButton.alpha = 0.1
            sendPushButton.userInteractionEnabled = false
        }
            
        else {
            messageTextView.alpha = 1
            messageTextView.userInteractionEnabled = true
            sendPushButton.alpha = 1
            sendPushButton.userInteractionEnabled = true
        }
        
    }
    
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
