//
//  ChatViewController.swift
//  m8up
//
//  Created by Gareth Harte on 02/05/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import Foundation

class ChatViewController : JSQMessagesViewController {
    
    //messages array
    var messages: [JSQMessage] = []
    
    //id for a match
    var matchID: String?
    
    //create MessageListener object
    var messageListener: MessageListener?
    
    //set up the bubble for outgoing messages
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    
    //set up the bubble for incomming messages
    let incommingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
    
    var avatars: NSMutableDictionary = [:]
    
    override func viewDidLoad () {
        super.viewDidLoad()
        //Do any additional setup after loading the view. 
        
        //Hiding avatars due to bug, will fix when JSQMessages lib is updated
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        //hide the bab bar so that we can bring up the keyboard
        self.tabBarController?.tabBar.hidden = true
        
        //if a matchID exists store it in a constant called 'id'. Fetch previous messages using id
        if let id = matchID {
            fetchMessages(id, {
                messages in
                
                for m in messages {
                    self.messages.append(JSQMessage(senderId: m.senderID, senderDisplayName: m.senderID, date: m.date, text: m.message))
                }
                self.finishReceivingMessage()
            })
        }
        
    }
    
    //check if new messages were received while not viewing the ChatViewController and load them.
    override func viewWillAppear(animated: Bool) {
        if let id = matchID {
            messageListener = MessageListener(matchID: id, startDate: NSDate(), callback: {
                message in
                self.messages.append(JSQMessage(senderId: message.senderID, senderDisplayName: message.senderID, date: message.date, text: message.message))
                self.finishReceivingMessage()
            })
        }
    }
    
    //stop listening for messages when leaving the ChatViewController
    override func viewWillDisappear(animated: Bool) {
        messageListener?.stop()
    }
    
    override var senderId: String! {
        get {
            return currentUser()!.id
        }
        
        set {
            super.senderId = newValue
        }
    }
    
    override var senderDisplayName: String! {
        get {
            return currentUser()!.name
        }
        
        set {
            super.senderDisplayName = newValue
        }
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        var data = self.messages[indexPath.row]
        return data
    }
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        
        var data = self.messages[indexPath.row]
        if data.senderId == PFUser.currentUser().objectId {
            return outgoingBubble
        }
        else {
            return incommingBubble
        }
        
    }
    
   
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        let m = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        //self.messages.append(m)
        if let id = matchID {
            saveMessage(id, Message(message: text, senderID: senderId, date: date))
            
        }
        
        
        finishSendingMessage()
    }
    
}