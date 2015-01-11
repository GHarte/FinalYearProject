//
//  SignUpViewController.swift
//  m8up
//
//  Created by Gareth Harte on 06/12/2014.
//  Copyright (c) 2014 m8up. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.alpha = 0
        var user = PFUser.currentUser()
        
        var FBSession = PFFacebookUtils.session()
        var accessToken = FBSession.accessTokenData.accessToken
        
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token=" + accessToken)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            let image = UIImage(data: data)
            
            self.profileImageView.image = image
            
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
            self.profileImageView.layer.borderWidth = 3.0
            self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
            
            user["image"] = data
            
            user.saveInBackgroundWithTarget(user, selector: nil)
            
            FBRequestConnection.startForMeWithCompletionHandler({
                connection, result, error in
                
                user["gender"] = result["gender"]
                user["name"] = result["name"]
                
                user.saveInBackgroundWithTarget(user, selector: nil)
                
                // println(result)
                
                let name: AnyObject! = user["name"]
                
                self.nameLabel.text = "\(name)"
                self.nameLabel.alpha = 1
                
            })
            
        })
        
    }
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication()).delegate as AppDelegate
        
        appDelegate.window?.rootViewController = ((UIStoryboard(name: "Main", bundle: NSBundle .mainBundle()).instantiateInitialViewController()) as UIViewController)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
