//
//  settingsViewController.swift
//  m8up
//
//  Created by Gareth Harte on 10/01/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var userInfoView: UIView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var userJobLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()
        var picData = (user["image"] as! NSData)
        var userPic = UIImage(data: picData)
        profilePicImageView.image = userPic
        
        profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.width / 2
        profilePicImageView.clipsToBounds = true
        profilePicImageView.layer.borderWidth = 3.0
        profilePicImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        let firstname: AnyObject! = user["firstname"]
        let firstnameString = "\(firstname)" as NSString
        
        userNameLabel.text = firstnameString as String
        
        let job: AnyObject! = user["job"];
        let jobString = "\(job)" as NSString
        
        userJobLabel.text = jobString as String
        
        
    }
    
    
    
    @IBAction func viewProfileButtonPressed(sender: UIButton) {
        
    }
    
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        
        var alertController = UIAlertController(title: "Are you sure you wish to log out?", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        var logout = UIAlertAction(title: "Logout", style: UIAlertActionStyle.Destructive) { (alert: UIAlertAction!) -> Void in
            
            PFUser.logOut()
            
            let appDelegate: AppDelegate = (UIApplication.sharedApplication()).delegate as! AppDelegate
            
            let rootController:UIViewController = ((UIStoryboard(name: "Main", bundle: NSBundle .mainBundle()).instantiateViewControllerWithIdentifier("main")) as! UIViewController)
            let navigationController:UINavigationController = (UINavigationController(rootViewController: rootController))
            navigationController.navigationBar.hidden = true
            
            appDelegate.window?.rootViewController = navigationController
            
        }
        
        var cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (alert: UIAlertAction!) -> Void in
            
            alertController.dismissViewControllerAnimated(true, completion: nil)
            
        }
        
        alertController.addAction(logout)
        alertController.addAction(cancel)
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
