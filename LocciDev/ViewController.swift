//
//  ViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/18/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblOne: UILabel!
    @IBOutlet weak var lblTwo: UILabel!
    @IBOutlet weak var lblThree: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Make all description labels hidden.
        lblOne.alpha = 0.0
        lblTwo.alpha = 0.0
        lblThree.alpha = 0.0
        
        btnContinue.alpha = 0.0
        // Making the button rounded at the corners
        btnContinue.layer.cornerRadius = 15.0
        
        lblOne.text = "Store notes based on location."
        lblTwo.text = "Get notified when you are near your note."
        //lblThree.text = "Share your notes with your friends via text, email or social media."
        
        lblThree.text = "Your notes are private and accessible only to you."
        
        btnContinue.setTitle("continue", forState: UIControlState.Normal)
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch1.0")){
            println("First Launch welcome 1")
            fnAnimateLabelAndButton()
        } else {
            println("Launch Home Screen : Direct")
            let vcHomeScreen = self.storyboard?.instantiateViewControllerWithIdentifier("vcHomeScreen") as HomeScreenViewController
            
            self.navigationController?.pushViewController(vcHomeScreen, animated: true)
        }
    }
    
    func fnAnimateLabelAndButton()
    {
        UIView.animateWithDuration(2.0, animations: {
            self.lblOne.alpha = 1.0
            }, completion: { (valueOne: Bool) in
                UIView.animateWithDuration(2.0, animations: {
                    self.lblTwo.alpha = 1.0
                    }, completion: { (valueTwo: Bool) in
                        UIView.animateWithDuration(2.0, animations: {
                            self.lblThree.alpha = 1.0
                            }, completion: { (valueThree : Bool) in
                                UIView.animateWithDuration(2.0, animations: {
                                    self.btnContinue.alpha = 1.0
                                    }, completion: nil)
                        })
                })
        })
    }
    
    
    @IBAction func fnContinueToExample(sender: UIButton) {
        //We want to show new examples now.
        
        if(!NSUserDefaults.standardUserDefaults().boolForKey("firstlaunch1.0")){
            println("First Launch welcome 2")
            //Make all description labels hidden.
            lblOne.alpha = 0.0
            lblTwo.alpha = 0.0
            lblThree.alpha = 0.0
            
            btnContinue.alpha = 0.0
            
            lblOne.text = "Next time I am here, talk to the supervisor!"
            lblTwo.text = "Milk.Bread.Ice Cream!\nLoyalty Card #123456789."
            lblThree.text = "Jimmy will love this place!."
            
            btnContinue.setTitle("start", forState: UIControlState.Normal)
            
            fnAnimateLabelAndButton()
            
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "firstlaunch1.0")
            NSUserDefaults.standardUserDefaults().synchronize();
        } else {
            println("Launch Home Screen : Button")
            let vcHomeScreen = self.storyboard?.instantiateViewControllerWithIdentifier("vcHomeScreen") as HomeScreenViewController
            
            self.navigationController?.pushViewController(vcHomeScreen, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

