//
//  ViewController.swift
//  LocciDev
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
        // Do any additional setup after loading the view, typically from a nib.
        
        //Make all description labels hidden.
        lblOne.alpha = 0.0
        lblTwo.alpha = 0.0
        lblThree.alpha = 0.0
        
        btnContinue.alpha = 0.0
        // Making the button rounded at the corners
        btnContinue.layer.cornerRadius = 15.0
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

