//
//  PageViewController.swift
//  m8up
//
//  Created by Gareth Harte on 30/04/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    let m8upVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("m8upVC") as! UIViewController
    let profileVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("profileVC") as! UIViewController
    let matchesVC: UIViewController! = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MatchesNavController") as! UIViewController
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = UIColor.whiteColor()
        dataSource = self // equal to this instance of the view controller
        self.setViewControllers([m8upVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    // MARK: UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController {
        case m8upVC:
            return profileVC
        case profileVC:
            return nil
        case matchesVC:
            return m8upVC
        default:
            return nil
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        switch viewController {
        case m8upVC:
            return matchesVC
        case profileVC:
            return m8upVC
        default:
            return nil
        }
        
    }


}
