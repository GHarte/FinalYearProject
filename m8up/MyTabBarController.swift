//
//  MyTabBarController.swift
//  m8up
//
//  Created by Gareth Harte on 07/12/2014.
//  Copyright (c) 2014 m8up. All rights reserved.
//

import UIKit

extension UIImage {
    
    //http://stackoverflow.com/questions/25052729/default-tab-bar-item-colors-using-swift-xcode-6
    
    func imageWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        let context = UIGraphicsGetCurrentContext() as CGContextRef
        CGContextTranslateCTM(context, 0, self.size.height)
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height) as CGRect
        CGContextClipToMask(context, rect, self.CGImage)
        tintColor.setFill()
        CGContextFillRect(context, rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

class MyTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var myColour = UIColor(red: 163/255.0, green: 114/255.0, blue: 206/255.0, alpha: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: myColour], forState:.Selected)
        
        for item in self.tabBar.items as! [UITabBarItem] {
            if let image = item.image {
                item.selectedImage = image.imageWithColor(myColour).imageWithRenderingMode(.AlwaysOriginal)
            }
        }
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
