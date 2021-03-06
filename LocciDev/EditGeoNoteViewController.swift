//
//  EditGeoNoteViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 1/19/15.
//  Copyright (c) 2015 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit
import CoreData

protocol NoteUpdatedDelegate {
    func userDidUpdateNote(_noteTitle: NSString, _noteText: NSString)
}

class EditGeoNoteViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    
    var tableData: Array<AnyObject> = []
    
    var noteId: integer_t = -1
    var noteTitle: String = "Title"
    var noteText: String = "Lorem Ipsum"
    
    var existingNote: NSManagedObject!
    
    var delegate: NoteUpdatedDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        txtNote.layer.cornerRadius = 15.0
        
        if noteId == -1 {
            print("ERROR: invalid note id")
        }
        
        self.txtTitle.delegate = self
        
        txtTitle.text = noteTitle
        txtNote.text = noteText
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    @IBAction func CancelEdit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func SaveEdit(sender: AnyObject) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        if (existingNote != nil) {
            existingNote.setValue(txtNote.text as String, forKey: "text")
            existingNote.setValue(txtTitle.text as String?, forKey: "title")
        } else {
            print("ERROR: existingNote should not be nil!")
        }
        
        do {
            try context.save()
        } catch _ {
        }
        
        if (delegate != nil) {
            let _noteTitle: NSString = txtTitle.text!
            let _noteText: NSString = txtNote.text
            delegate!.userDidUpdateNote(_noteTitle, _noteText: _noteText)
        }
        
        self.navigationController?.popViewControllerAnimated(true)
    }
}
