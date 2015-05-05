//
//  DiscoveryViewController.swift
//  m8up
//
//  Created by Gareth Harte on 28/01/2015.
//  Copyright (c) 2015 m8up. All rights reserved.
//

import UIKit

class DiscoveryViewController: UIViewController {
    
    var userDefaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var ageRangeLabelOne: UILabel!
    
    @IBOutlet weak var ageRangeLabelTwo: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var ageSlider: NMRangeSlider!
    
    @IBOutlet weak var allSwitch: UISwitch!
    
    @IBOutlet weak var jobSwitch: UISwitch!
    
    @IBOutlet weak var gamesSwitch: UISwitch!
    
    @IBOutlet weak var moviesSwitch: UISwitch!
    
    @IBOutlet weak var sportSwitch: UISwitch!
    
    @IBOutlet weak var tvShowsSwitch: UISwitch!
    
    @IBOutlet weak var musicSwitch: UISwitch!
    
    @IBOutlet weak var booksSwitch: UISwitch!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //load from NSUserDefaults
        loadFromUserDefaults()
        
        //setup view
        self.configureAgeSlider()
        self.checkAllSwitch()
        
    }
    
    func loadFromUserDefaults(){
        
        //label and slider values
        
        if (userDefaults.objectForKey("dist") != nil){
            var distanceInKM = userDefaults.objectForKey("dist") as? NSString
            distanceLabel.text = distanceInKM as? String
            
            distanceSlider.value = distanceInKM!.floatValue
            //set slider value. Don't know how to do this yet
        }
        
        
        //Switches
        
        if (userDefaults.objectForKey("allSwitch") != nil){
            allSwitch.on = userDefaults.objectForKey("allSwitch") as! Bool
        }
        
        if (userDefaults.objectForKey("jobSwitch") != nil){
            jobSwitch.on = userDefaults.objectForKey("jobSwitch") as! Bool
        }
        
        if (userDefaults.objectForKey("gamesSwitch") != nil){
            gamesSwitch.on = userDefaults.objectForKey("gamesSwitch") as! Bool
        }
        
        if (userDefaults.objectForKey("moviesSwitch") != nil){
            moviesSwitch.on = userDefaults.objectForKey("moviesSwitch") as! Bool
        }
        
        if (userDefaults.objectForKey("sportsSwitch") != nil){
            sportSwitch.on = userDefaults.objectForKey("sportsSwitch") as! Bool
        }
        
        if (userDefaults.objectForKey("tvShowsSwitch") != nil){
            tvShowsSwitch.on = userDefaults.objectForKey("tvShowsSwitch") as! Bool
        }
        
        if (userDefaults.objectForKey("musicSwitch") != nil){
            musicSwitch.on = userDefaults.objectForKey("musicSwitch") as! Bool
        }
        
        if (userDefaults.objectForKey("booksSwitch") != nil){
            booksSwitch.on = userDefaults.objectForKey("booksSwitch") as! Bool
        }
        
    }
    
    func configureAgeSlider() {
        
        self.ageSlider.lowerValue = 1.8
        self.ageSlider.upperValue = 2.2
        self.ageSlider.minimumValue = 1.8
        self.ageSlider.maximumValue = 8.0
        self.ageSlider.minimumRange = 0.4
        
        var myPurpleColor:UIColor = UIColor(red: 174.0/255.0, green: 93.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        
        ageSlider.tintColor = myPurpleColor
        
    }
    
    func checkAllSwitch() {
        
        if allSwitch.on == true{
            
            jobSwitch.enabled = false
            
            gamesSwitch.enabled = false
            
            moviesSwitch.enabled = false
            
            sportSwitch.enabled = false
            
            tvShowsSwitch.enabled = false
            
            musicSwitch.enabled = false
            
            booksSwitch.enabled = false
        }
            
        else if allSwitch.on == false{
            
            jobSwitch.enabled = true
            
            gamesSwitch.enabled = true
            
            moviesSwitch.enabled = true
            
            sportSwitch.enabled = true
            
            tvShowsSwitch.enabled = true
            
            musicSwitch.enabled = true
            
            booksSwitch.enabled = true
        }
        
    }
    
    @IBAction func ageSliderValueChange(sender: NMRangeSlider) {
        ageRangeLabelOne.text = "\(integer_t(ageSlider.lowerValue * 10))"
        ageRangeLabelTwo.text = "\(integer_t(ageSlider.upperValue * 10))"
        
        //userDefaults
        
    }
    
    
    @IBAction func distanceSliderValueChanged(sender: AnyObject) {
        var distanceInKM = "\(integer_t(distanceSlider.value))"
        distanceLabel.text = distanceInKM
        
        userDefaults.setObject(distanceInKM, forKey: "dist")
        
    }
    
    @IBAction func allSwitchValueChanged(sender: UISwitch) {
        
        self.checkAllSwitch()
        var isOn:Bool
        
        if allSwitch.on{
            isOn = true
            userDefaults.setBool(isOn, forKey: "allSwitch")
        }
        else{
            isOn = false
            userDefaults.setBool(isOn, forKey: "allSwitch")
        }
        
    }
    
    @IBAction func jobSwitchValueChanged(sender: UISwitch) {
        userDefaults.setBool(jobSwitch.on, forKey: "jobSwitch")
        
        // set up way to alter the user search query
        
    }
    
    @IBAction func videoGamesSwitchValueChanged(sender: UISwitch) {
        userDefaults.setBool(gamesSwitch.on, forKey: "gamesSwitch")
    }
    
    @IBAction func moviesSwitchValueChanged(sender: AnyObject) {
        userDefaults.setBool(moviesSwitch.on, forKey: "moviesSwitch")
    }
    
    @IBAction func sportsSwitchValueChanged(sender: UISwitch) {
        userDefaults.setBool(sportSwitch.on, forKey: "sportsSwitch")
    }
    
    @IBAction func tvShowsSwitchValueChanged(sender: UISwitch) {
        userDefaults.setBool(tvShowsSwitch.on, forKey: "tvShowsSwitch")
    }
    
    @IBAction func musicSwitchValueChanged(sender: UISwitch) {
        userDefaults.setBool(musicSwitch.on, forKey: "musicSwitch")
    }
    
    @IBAction func booksSwitchValueChanged(sender: UISwitch) {
        userDefaults.setBool(booksSwitch.on, forKey: "booksSwitch")
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
