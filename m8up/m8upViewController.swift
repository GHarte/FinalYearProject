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
    @IBOutlet weak var noUserLabel: UILabel!
    @IBOutlet weak var distanceToUserLabel: UILabel!
    
    
    
    var i = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardStackView.backgroundColor = UIColor.clearColor()
        
        m8downButton.setImage(UIImage(named: "nah-button-pressed"), forState: UIControlState.Highlighted)
        m8upButton.setImage(UIImage(named: "yeah-button-pressed"), forState: UIControlState.Highlighted)
        
        
        //get current location every time app is re launched
        
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint: PFGeoPoint!, error: NSError!) -> Void in
            
            if error == nil {
                println(geoPoint)
                user["location"] = geoPoint
                user.saveInBackgroundWithBlock(nil)
            }
        }
        
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
            
            //distance test
            if let kilometers = self.frontCard?.user.currentLocation.distanceInKilometersTo(currentUser()?.currentLocation){
            let distanceToUser = String(format: "%.1fkm away", kilometers)
            self.distanceToUserLabel.text = distanceToUser
            }
            
            else {
                self.distanceToUserLabel.hidden = true
            }
            
            
        })
        
        //self.checkRemainingUsers()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        
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
        
        //if a back card exists, move it to the front
        if let card = backCard {
            frontCard = card
            UIView.animateWithDuration(0.2, animations: {
                self.frontCard!.swipeView.frame = self.createCardFrame(self.frontCardTopMargin)
                
                //update name label
                self.userNameLabel.text = self.frontCard?.user.name
                
                //distance test
                if let kilometers = self.frontCard?.user.currentLocation.distanceInKilometersTo(currentUser()?.currentLocation){
                    let distanceToUser = String(format: "%.1f km away", kilometers)
                    self.distanceToUserLabel.text = distanceToUser
                }
                
            })
        }
        
        if let card = self.popCard() {
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        }
        
       
        
    }
    
    func checkRemainingUsers() {
        if users?.count == 0 {
            println("no users left")
            userNameLabel.hidden = true
            noUserLabel.hidden = false
            distanceToUserLabel.hidden = true
        }
        else if users?.count > 0 {
            userNameLabel.hidden = false
            noUserLabel.hidden = true
            distanceToUserLabel.hidden = false
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
