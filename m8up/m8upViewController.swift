//
//  m8upViewController.swift
//  m8up
//
//  Created by Gareth Harte on 06/12/2014.
//  Copyright (c) 2014 m8up. All rights reserved.
//

import UIKit

class m8upViewController: UIViewController, SwipeViewDelegate {
    
    struct Card {
        let cardView: CardView
        let swipeView: SwipeView
        let user: User
    }

    let frontCardTopMargin: CGFloat = 0
    let backCardTopMargin: CGFloat = 10
    
    @IBOutlet weak var cardStackView: UIView!
    
    var backCard: Card?
    var frontCard: Card?
    
    var users: [User]?
    
    @IBOutlet weak var m8upButton: UIButton!
    @IBOutlet weak var m8downButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    
    var i = 10
    
    var usernames = [String]()
    var userImages = [NSData]()
    var firstnames = [String]()
    var currentUser = 0
    
    var yFromCenter: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardStackView.backgroundColor = UIColor.clearColor()
        
        m8downButton.setImage(UIImage(named: "nah-button-pressed"), forState: UIControlState.Highlighted)
        m8upButton.setImage(UIImage(named: "yeah-button-pressed"), forState: UIControlState.Highlighted)
        
        fetchUnviewedUsers({
            returnedUsers in
            self.users = returnedUsers
            
            if let card = self.popCard() {
                self.frontCard = card
                self.cardStackView.addSubview(self.frontCard!.swipeView)
            }
            
            if let card = self.popCard() {
                self.backCard = card
                self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
                self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
            }
            
        })
    
    }
    
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    private func createCard(user: User) -> Card {
        let cardView = CardView()
        cardView.name = user.name
        user.getPhoto({
            image in
            cardView.image = image
        })
        
        
        let swipeView = SwipeView(frame: createCardFrame(0))
        swipeView.delegate = self
        swipeView.innerView = cardView
        return Card(cardView: cardView, swipeView: swipeView, user: user)
    }
    
    private func popCard() -> Card? {
        if users != nil && users?.count > 0 {
            return createCard(users!.removeLast())
        }
        return nil
    }
    
    private func switchCards() {
        if let card = backCard {
            frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
            })
        }
        
        if let card = self.popCard() {
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        }
    }
    
    // MARK: - SwipeViewDelegate
    
    func swipedLeft() {
        println("left")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveSkip(frontCard.user)
            switchCards()
        }
    }
    
    func swipedRight() {
        println("right")
        if let frontCard = frontCard {
            frontCard.swipeView.removeFromSuperview()
            saveLike(frontCard.user)
            switchCards()
        }
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
                            self.userImages.append(user["image"] as! NSData)
                            self.firstnames.append(user["firstname"] as! NSString as String)
                            
                        }
                        
                    }
                    
                    var userPic = UIImage(data: self.userImages[0])
                    var username = NSString(string: self.firstnames[0])
                    
                //    self.presentUserImage(userPic!, name: username)
                    
//                    self.swipeView.imageView.image = userPic
//                    
//                    self.view.addSubview(self.swipeView)
                    
                })
                
                user.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                    if error != nil{
                        //ProgressHUD.showError("Network error")
                    }
                }
                
            }
            
        }
        
    }
//    
//    // MARK: - Create User Image
//    func presentUserImage(pic: UIImage, name:NSString) {
//        
//        //Remove the current image from superview code moved due to bug
//        
//        m8ImageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.width))
//        m8ImageView.backgroundColor = UIColor.blackColor()
//        m8ImageView.image = pic
//        m8ImageView.contentMode = UIViewContentMode.ScaleAspectFit
//        self.view.addSubview(m8ImageView)
//        
//        var gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
//        m8ImageView.addGestureRecognizer(gesture)
//        
//        m8ImageView.userInteractionEnabled = true
//        
//        userNameLabel.text = name as String
//        
//    }
    
//    // MARK: - Swipe Gesture
//    func wasDragged(gesture: UIPanGestureRecognizer) {
//        
//        let translation = gesture.translationInView(self.view)
//        
//        yFromCenter += translation.y
//        
//        m8ImageView.center = CGPoint(x: m8ImageView.center.x, y: m8ImageView.center.y + translation.y)
//        
//        gesture.setTranslation(CGPointZero, inView: self.view)
//        
//        var scale = min(100 / abs(yFromCenter), 10)
//        var stretch: CGAffineTransform
//        
//        if (translation.y <= 0) {
//            stretch = CGAffineTransformMakeScale(scale, scale)
//        }
//            
//        else {
//            stretch = CGAffineTransformMakeScale(2, scale)
//        }
//        
//        m8ImageView.transform = stretch
//        
//        if gesture.state == UIGestureRecognizerState.Ended {
//            
//            if (m8ImageView.center.y < self.view.bounds.height / 2 ) {
//                println("m8up")
//                self.currentUser++
//                m8ImageView.removeFromSuperview()
//            }
//            else if (m8ImageView.center.y > self.view.bounds.height / 2 ) {
//                println("m8down")
//                self.currentUser++
//                m8ImageView.removeFromSuperview()
//            }
//            
//            // get next user every swipe
//            
//            if self.currentUser < self.userImages.count {
//                
//                var nextUserPic: UIImage = UIImage(data: self.userImages[self.currentUser])!
//                var nextUserName: NSString = NSString(UTF8String: self.firstnames[self.currentUser])!
//                
//                presentUserImage(nextUserPic, name: nextUserName)
//                
//                yFromCenter = 0
//                
//            }
//            else {
//                
//                var alert = UIAlertView(title: "No One Nearby", message: "There is nobody new nearby, please try again later", delegate: self, cancelButtonTitle: "Ok")
//                alert.show()
//                
//            }
//        }
//    }
//    
    // MARK: - IBActions
    
    @IBAction func m8upButtonPressed(sender: UIButton) {
        
        if let card = frontCard {
            
            card.swipeView.swipe(SwipeView.Direction.Right)
            
        }
      
        
    }
    
    @IBAction func m8downButtonPressed(sender: UIButton) {
        
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Left)
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
