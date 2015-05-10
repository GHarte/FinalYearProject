//
//  Message.swift
//  m8up
//
//  Created by Gareth Harte on 05/05/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import Foundation

struct Message {
    let message: String
    let senderID: String
    let date: NSDate
}

class MessageListener {
    var currentHandle: UInt?
    
    init (matchID: String, startDate: NSDate, callback: (Message) -> ()) {
        
        let handle = ref.childByAppendingPath(matchID).queryOrderedByKey().queryStartingAtValue(dateFormatter().stringFromDate(startDate)).observeEventType(FEventType.ChildAdded, withBlock: {
            snapshot in
            let message = snapshotToMessage(snapshot)
            callback(message)
        })
        self.currentHandle = handle
    }
    
    func stop() {
        if let handle = currentHandle {
            ref.removeObserverWithHandle(handle)
            currentHandle = nil
        }
    }
}

private let ref = Firebase(url: "https://m8up.firebaseio.com/messages") //Firebase Reference
private let dateFormat = "yyyyMMddHHmmss"

private func dateFormatter() -> NSDateFormatter {
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = dateFormat
    return dateFormatter
}

func saveMessage(matchID: String, message: Message) {
    ref.childByAppendingPath(matchID).updateChildValues([dateFormatter().stringFromDate(message.date) : ["message" : message.message, "sender" : message.senderID]])
}

private func snapshotToMessage(snapshot: FDataSnapshot) -> Message {
    
    let date = dateFormatter().dateFromString(snapshot.key)
    let sender = snapshot.value["sender"] as? String
    let text = snapshot.value["message"] as? String
    return Message(message: text!, senderID: sender!, date: date!)
    
}

//done asynchronously, not through the main thread as to do so would make the UI unresponsive
func fetchMessages(matchID: String, callback: ([Message]) -> ()) {
    
    ref.childByAppendingPath(matchID).queryLimitedToFirst(25).observeSingleEventOfType(FEventType.Value, withBlock: {
        snapshot in
        
        var messages = Array<Message>()
        let enumerator = snapshot.children
        
        while let data = enumerator.nextObject() as? FDataSnapshot {
            messages.append(snapshotToMessage(data))
        }
        callback(messages)
    })
    
}