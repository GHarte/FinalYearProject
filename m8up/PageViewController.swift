//
//  PageViewController.swift
//  m8up
//
//  Created by Gareth Harte on 30/04/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    let m8upVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("m8upVC") as! UIViewController
    let profileVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("profileVC") as! UIViewController
    let matchesVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MatchesNavController") as! UIViewController
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
