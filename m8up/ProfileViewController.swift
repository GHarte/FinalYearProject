//
//  ProfileViewController.swift
//  m8up
//
//  Created by Gareth Harte on 30/04/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var titleNavItem: UINavigationItem!
    
    //may need to check if opening your profile or someone elses in view will appear as view did load is only used once when app is opened.

    override func viewDidLoad() {
        super.viewDidLoad()

        // Put in check to see if opening currentuser profile or someone elses
        
        var title: String
        title = currentUser()!.name
        titleNavItem.title = title
        
        usernameLabel.text = currentUser()?.name
        
        currentUser()?.getPhoto({
            image in
            self.profileImageView.image = image
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
            self.profileImageView.layer.borderWidth = 5.0
            self.profileImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
