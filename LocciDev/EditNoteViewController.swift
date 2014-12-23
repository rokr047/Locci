//
//  EditNoteViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/22/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit

//protocol to transfer note data back to Create Note Screen
protocol NoteEnteredDelegate {
    func userDidEnterNote(noteText: NSString)
}

class EditNoteViewController: UIViewController {

    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var btnDone: UIButton!
    
    var delegate:NoteEnteredDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtNote.layer.cornerRadius = 15.0
        btnDone.layer.cornerRadius = 15.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func UpdateNote(sender: AnyObject) {
        if (delegate != nil){
            let note: NSString = txtNote.text
            delegate!.userDidEnterNote(note)
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
}
