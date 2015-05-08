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
            
            //update name label
            self.userNameLabel.text = self.frontCard?.user.name
            
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
                
                //update name label
                self.userNameLabel.text = self.frontCard?.user.name
                
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
                            
                            
                            
                        }
                        
                    }
                    
                
                    
               
                    
                })
                
                user.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
                    if error != nil{
                        //ProgressHUD.showError("Network error")
                    }
                }
                
            }
            
        }
        
    }
    
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
