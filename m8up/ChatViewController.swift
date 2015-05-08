//
//  ChatViewController.swift
//  m8up
//
//  Created by Gareth Harte on 02/05/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import Foundation

class ChatViewController : JSQMessagesViewController {
    
    var messages: [JSQMessage] = []
    
    var matchID: String?
    
    var messageListener: MessageListener?
    
    let outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleBlueColor())
    let incommingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    var avatars: NSMutableDictionary = [:]
    
    override func viewDidLoad () {
        super.viewDidLoad()
        //Do any additional setup after loading the view. 
        
        //Hiding avatars due to bug, will fix when lib is updated 
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero
        
        self.tabBarController?.tabBar.hidden = true
        
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
    
    override func viewWillAppear(animated: Bool) {
        if let id = matchID {
            messageListener = MessageListener(matchID: id, startDate: NSDate(), callback: {
                message in
                self.messages.append(JSQMessage(senderId: message.senderID, senderDisplayName: message.senderID, date: message.date, text: message.message))
                self.finishReceivingMessage()
            })
        }
    }
    
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