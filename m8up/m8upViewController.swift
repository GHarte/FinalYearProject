//
//  m8upViewController.swift
//  m8up
//
//  Created by Gareth Harte on 06/12/2014.
//  Copyright (c) 2014 m8up. All rights reserved.
//

import UIKit

class m8upViewController: UIViewController {
    
    @IBOutlet weak var m8upButton: UIButton!
    @IBOutlet weak var m8downButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var i = 10
    
    var usernames = [String]()
    var userImages = [NSData]()
    var currentUser = 0
    
    var m8ImageView = UIImageView()
    
    var yFromCenter: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUsersForSwipe()
        
        
        //        addDummyUser("http://img2.wikia.nocookie.net/__cb20120728075452/crashban/images/e/eb/Coco.JPG")
        //        addDummyUser("http://img2.timeinc.net/people/i/2012/database/120312/jennifer-lawrence-300.jpg")
        //        addDummyUser("http://media.tumblr.com/9ecabe989142c8ec0c99992d535b277c/tumblr_inline_ms9xajqGOi1qz4rgp.jpg")
        //        addDummyUser("http://iv1.lisimg.com/image/3840525/600full-iain-glen.jpg")
        //        addDummyUser("http://image-cdn.zap2it.com/images/andy-samberg-bbc-cuckoo-gi.jpg")
        //        addDummyUser("http://media.alistdaily.com/editorial/2013/05/Jon-Snow-S3.jpg")
        
        // Do any additional setup after loading the view.
        
    }
    
    
    // MARK: - Populate User Database
    func addDummyUser(urlString:String) {
        
        var newUser:PFUser = PFUser()
        
        let url = NSURL(string: urlString)
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            
            newUser["image"] = data
            
            newUser["gender"] = "female"
            
            var lat = Double(53 + self.i)
            var lon = Double(-6 + self.i)
            
            self.i = self.i + 5
            
            var location = PFGeoPoint(latitude: lat, longitude: lon)
            
            newUser["location"] = location
            
            newUser.username = "\(self.i)"
            newUser.password = "password"
            
            newUser.signUp()
            
        })
    }
    
    // MARK: - Load Users
    func loadUsersForSwipe() {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error == nil {
                
                println(geoPoint)
                
                var user = PFUser.currentUser()
                
                user["location"] = geoPoint
                
                // Get nearby users
                
                // Create a query for users
                var query = PFUser.query()
                // Interested in locations near user.
                query.whereKey("location", nearGeoPoint:geoPoint)
                // Limit what could be a lot of points.
                query.limit = 10
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    
                    for user in users {
                        
                        // Stop user from seeing themselves
                        if PFUser.currentUser().username != user.username {
                            
                            self.usernames.append(user.username)
                            self.userImages.append(user["image"] as NSData)
                            
                        }
                        
                    }
                    
                    var userPic = UIImage(data: self.userImages[0])
                    
                    self.presentUserImage(userPic!)
                    
                })
                
                user.saveInBackgroundWithTarget(user, selector: nil)
                
            }
            
        }
        
    }
    
    // MARK: - Create User Image
    func presentUserImage(pic: UIImage) {
        
        //Remove the current image from superview code moved due to bug
        
        m8ImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.width))
        m8ImageView.backgroundColor = UIColor.blackColor()
        m8ImageView.image = pic
        m8ImageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.view.addSubview(m8ImageView)
        
        var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        m8ImageView.addGestureRecognizer(gesture)
        
        m8ImageView.userInteractionEnabled = true
        
    }
    
    // MARK: - Swipe Gesture
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        
        yFromCenter += translation.y
        
        m8ImageView.center = CGPoint(x: m8ImageView.center.x, y: m8ImageView.center.y + translation.y)
        
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        var scale = min(100 / abs(yFromCenter), 10)
        var stretch: CGAffineTransform
        
        if (translation.y <= 0) {
            stretch = CGAffineTransformMakeScale(scale, scale)
        }
            
        else {
            stretch = CGAffineTransformMakeScale(2, scale)
        }
        
        m8ImageView.transform = stretch
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            if (m8ImageView.center.y < self.view.bounds.height / 2 ) {
                println("m8up")
                self.currentUser++
                m8ImageView.removeFromSuperview()
            }
            else if (m8ImageView.center.y > self.view.bounds.height / 2 ) {
                println("m8down")
                self.currentUser++
                m8ImageView.removeFromSuperview()
            }
            
            // get next user every swipe
            
            if self.currentUser < self.userImages.count {
                
                var nextUserPic: UIImage = UIImage(data: self.userImages[self.currentUser])!
                
                presentUserImage(nextUserPic)
                
                yFromCenter = 0
                
            }
            else {
                
                var alert = UIAlertView(title: "No One Nearby", message: "There is nobody new nearby, please try again later", delegate: self, cancelButtonTitle: "Ok")
                alert.show()
                
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func m8upButtonPressed(sender: UIButton) {
        
        //Animate this like the swipe gesture
        
        self.currentUser++
        m8ImageView.removeFromSuperview()
        
        if self.currentUser < self.userImages.count {
            
            var nextUserPic: UIImage = UIImage(data: self.userImages[self.currentUser])!
            
            presentUserImage(nextUserPic)
            
            println("m8up")
            
        }
        else {
            
            var alert = UIAlertView(title: "No One Nearby", message: "There is nobody new nearby, please try again later", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            
        }
        
    }
    
    @IBAction func m8downButtonPressed(sender: UIButton) {
        
        //Animate this like the swipe gesture
        
        self.currentUser++
        m8ImageView.removeFromSuperview()
        
        if self.currentUser < self.userImages.count {
            
            var nextUserPic: UIImage = UIImage(data: self.userImages[self.currentUser])!
            
            presentUserImage(nextUserPic)
            
            println("m8down")
            
        }
        else {
            
            var alert = UIAlertView(title: "No One Nearby", message: "There is nobody new nearby, please try again later", delegate: self, cancelButtonTitle: "Ok")
            alert.show()
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
