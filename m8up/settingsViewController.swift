//
//  settingsViewController.swift
//  m8up
//
//  Created by Gareth Harte on 10/01/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController {
    
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    @IBOutlet weak var userInfoView: UIView!
    
    
    @IBOutlet weak var userNameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()
        var picData = (user["image"] as NSData)
        var userPic = UIImage(data: picData)
        profilePicImageView.image = userPic
        
        profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.width / 2
        profilePicImageView.clipsToBounds = true
        profilePicImageView.layer.borderWidth = 3.0
        profilePicImageView.layer.borderColor = UIColor.whiteColor().CGColor
        
        let name: AnyObject! = user["name"]
        userNameLabel.text = "\(name)"
        
        // Do any additional setup after loading the view.
        
        
    }
    
    @IBAction func viewProfileButtonPressed(sender: UIButton) {
        
    }
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        
        PFUser.logOut()
        
        let appDelegate: AppDelegate = (UIApplication.sharedApplication()).delegate as AppDelegate
        
        let rootController:UIViewController = ((UIStoryboard(name: "Main", bundle: NSBundle .mainBundle()).instantiateViewControllerWithIdentifier("main")) as UIViewController)
        let navigationController:UINavigationController = (UINavigationController(rootViewController: rootController))
        navigationController.navigationBar.hidden = true
        
        appDelegate.window?.rootViewController = navigationController
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
