//
//  ViewNoteViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/24/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit

class ViewNoteViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ShowActionSheet(sender: AnyObject) {
        let actionTitle = ""
        let actionMessage = "Actions for current note"
        
        let actionSheet = UIAlertController(title: actionTitle, message: actionMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let action1 = UIAlertAction(title: "Edit Note", style: UIAlertActionStyle.Default, handler: nil)
        let action2 = UIAlertAction(title: "Delete Note", style: UIAlertActionStyle.Destructive, handler: nil)
        let action3 = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionSheet.addAction(action1)
        actionSheet.addAction(action2)
        actionSheet.addAction(action3)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
}
