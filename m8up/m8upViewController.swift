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
    
    //cards
    var backCard: Card?
    var frontCard: Card?
    
    //user array
    var users: [User]?
    
    @IBOutlet weak var m8upButton: UIButton!
    @IBOutlet weak var m8downButton: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var noUserLabel: UILabel!
    @IBOutlet weak var distanceToUserLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cardStackView.backgroundColor = UIColor.clearColor()
        
        //set button images for when they are pressed. Cannot do this in storyboard.
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
    
    //create a card frame equal in size to the cardStackView on the storyboard
    private func createCardFrame(topMargin: CGFloat) -> CGRect {
        return CGRect(x: 0, y: topMargin, width: cardStackView.frame.width, height: cardStackView.frame.height)
    }
    
    //set up a cardView and place it into the SwipeView
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
    
    //take a user from the array and use it as a parameter for the createCard func
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
        
        //if the user array is not empty and the popCard function works, set the returned card as the back card
        
        if let card = self.popCard() {
            self.backCard = card
            self.backCard!.swipeView.frame = self.createCardFrame(self.backCardTopMargin)
            self.cardStackView.insertSubview(self.backCard!.swipeView, belowSubview: self.frontCard!.swipeView)
        }
        
       
        
    }
    
    //Check if the user array is empty and change UI if so.
    func checkRemainingUsers() {
        //test
        if users == nil {
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
    
    //if a front card exists, simulate swiping it to the right if the user presses the yeah button
    @IBAction func m8upButtonPressed(sender: UIButton) {
        
        if let card = frontCard {
            
            card.swipeView.swipe(SwipeView.Direction.Right)
            
        }
        
    }
    
    //if a front card exists, simulate swiping it to the left if the user presses the nah button
    @IBAction func m8downButtonPressed(sender: UIButton) {
        
        if let card = frontCard {
            card.swipeView.swipe(SwipeView.Direction.Left)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set the status bar colour to white
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}
