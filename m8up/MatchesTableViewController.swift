//
//  MatchesTableViewController.swift
//  m8up
//
//  Created by Gareth Harte on 02/05/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit

class MatchesTableViewController: UITableViewController {
    
    var matches: [Match] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        

    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Show tab bar
        self.tabBarController?.tabBar.hidden = false
        
//        navigationItem.titleView = UIImageView(image: UIImage(named: "chat-header"))

        
        fetchMatches({
            matches in
            self.matches = matches
            self.tableView.reloadData()
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return matches.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as! UserCell

        // Configure the cell...
        let user = matches[indexPath.row].user
        
        cell.nameLabel.text = user.name
        user.getPhoto({
            image in
            cell.avatarImageView.image = image
            })

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = ChatViewController()
        
        let match = matches[indexPath.row]
        vc.matchID = match.id
        vc.title = match.user.name
        
        navigationController?.pushViewController(vc, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }


   
}
