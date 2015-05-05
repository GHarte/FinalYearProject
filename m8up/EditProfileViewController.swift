//
//  EditProfileViewController.swift
//  m8up
//
//  Created by Gareth Harte on 28/01/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit



class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate{
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var jobTextField: UITextField!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var tvShowsTextField: UITextField!
    
    @IBOutlet weak var moviesTextField: UITextField!
    
    @IBOutlet weak var sportTextField: UITextField!
    
    @IBOutlet weak var videoGamesTextField: UITextField!
    
    @IBOutlet weak var musicTextField: UITextField!
    
    @IBOutlet weak var booksTextField: UITextField!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
   

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = currentUser()?.name
        
        currentUser()?.getPhoto({
            image in
            self.profileImageView.image = image
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
            self.profileImageView.clipsToBounds = true
            self.profileImageView.layer.borderWidth = 5.0
            self.profileImageView.layer.borderColor = UIColor.lightGrayColor().CGColor
        })
        
        
        
        scrollView.keyboardDismissMode = .OnDrag
        
    }
    
//    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//        self.scrollView.endEditing(true)
//        self.view.endEditing(true)
//        
//        
//    }
    
    override func viewWillAppear(animated: Bool) { //this needs to check if that data exists or not
        
//        var job: AnyObject = user["job"]
//        jobTextField.text = "\(job)"
//        
//        var town: AnyObject = user["town"]
//        locationTextField.text = "\(town)"
//        
//        var tvShows: AnyObject = user["tvshows"]
//        tvShowsTextField.text = "\(tvShows)"
//        
//        var movies: AnyObject = user["movies"]
//        moviesTextField.text = "\(movies)"
//        
//        var sports: AnyObject = user["sports"]
//        sportTextField.text = "\(sports)"
//        
//        var videoGames: AnyObject = user["videogames"]
//        videoGamesTextField.text = "\(videoGames)"
//    
//        var music: AnyObject = user["music"]
//        musicTextField.text = "\(music)"
//        
//        var books: AnyObject = user["books"]
//        booksTextField.text = "\(books)"
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        
        // maybe make these all uppercase or lowercase to avoid errors.
        
        user["job"] = jobTextField.text
        user["town"] = locationTextField.text
        user["tvshows"] = tvShowsTextField.text
        user["movies"] = moviesTextField.text
        user["sports"] = sportTextField.text
        user["videogames"] = videoGamesTextField.text
        user["music"] = musicTextField.text
        user["books"] = booksTextField.text
        
        user.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error != nil{
               // ProgressHUD.showError("Network error")
            }
        }
        
    }
    
    @IBAction func editProfilePicButtonPressed(sender: UIButton) {
        
     //   ShouldStartPhotoLibrary(self, true)
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        var image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        if image.size.width > 200 {
  //          image = ResizeImage(image, 200, 200)
        }
        
//        var picFile = PFFile(name: "picture.jpg", data: UIImageJPEGRepresentation(image, 0.6))
//        
//        picFile.saveInBackgroundWithBlock { (succeeded: Bool, error: NSError!) -> Void in
//            if error != nil{
//                ProgressHUD.showError("Network error")
//            }
//        }
        
        self.profileImageView.image = image
        
        //code for thumbnail
        
        
        var imageData: NSData = UIImageJPEGRepresentation(image, 0.6)
        user["image"] = imageData
        
        user.saveInBackgroundWithBlock { (success: Bool, error: NSError!) -> Void in
            if error != nil{
             //   ProgressHUD.showError("Network error")
            }
        }
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}
