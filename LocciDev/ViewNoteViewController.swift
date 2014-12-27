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
    }

    @IBAction func ShowActionSheet(sender: AnyObject) {
        let actionTitle = "actions for current note"
        let actionMessage = ""
        
        let actionSheet = UIAlertController(title: actionTitle, message: actionMessage, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let shareAction = UIAlertAction(title: "share", style: UIAlertActionStyle.Default, handler: nil)
        let editAction = UIAlertAction(title: "edit", style: UIAlertActionStyle.Default, handler: nil)
        let deleteAction = UIAlertAction(title: "delete", style: UIAlertActionStyle.Destructive, handler: nil)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
