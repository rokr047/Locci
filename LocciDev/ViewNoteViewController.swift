//
//  ViewNoteViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/24/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class ViewNoteViewController: UIViewController, MKMapViewDelegate, NoteUpdatedDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var noteId: integer_t = -1
    var noteTitle: String = ""
    var noteData: String = ""
    var locationName: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    var selectedNote: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBar.topItem?.title = noteTitle
        noteText.text = noteData
        
        //Set up Map View
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
    }
    
    override func viewDidAppear(animated: Bool) {
        //Add a pin to the map at the location where the user had saved the note
        let noteCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        let annotation = CustomAnnotation(coordinate: noteCoordinate, title: noteTitle, subtitle: locationName)
        //mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        
        let regionToZoom = MKCoordinateRegionMake(noteCoordinate, MKCoordinateSpanMake(0.003, 0.003))
        mapView.setRegion(regionToZoom, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func ShowActionSheet(sender: AnyObject) {
        //let actionTitle = "actions for current note"
        //let actionMessage = ""
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let shareAction = UIAlertAction(title: "Share", style: UIAlertActionStyle.Default, handler: fnShareActionHandler)
        let editAction = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default, handler: fnEditActionHandler)
        let deleteAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: fnDeleteActionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func fnShareActionHandler (action:UIAlertAction!) -> Void {
        let textToShare = "Hey check out my note @ \(locationName) : \(noteTitle).\n\(noteData). \nLat : \(latitude)\nLong : \(longitude).\nGet #Locci at rokr047.com/Locci"
        
        let objectsToShare = [textToShare]
            
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        //New Excluded Activities Code
        activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeSaveToCameraRoll]
            
        self.presentViewController(activityVC, animated: true, completion: nil)
    }
    
    func fnEditActionHandler (action:UIAlertAction!) -> Void {
        print("Note sent for editing.")
        //Trigger segue via code
        self.performSegueWithIdentifier("EditGeoNoteSegue", sender: nil)
    }
    
    func fnDeleteActionHandler (action:UIAlertAction!) -> Void {
        Notes.DeleteNote(noteId)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    @IBAction func ViewNoteDone(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditGeoNoteSegue" {
            let nextVC: EditGeoNoteViewController = segue.destinationViewController as! EditGeoNoteViewController
            
            nextVC.noteId = noteId
            nextVC.noteTitle = noteTitle
            nextVC.noteText = noteData
            nextVC.existingNote = selectedNote
            
            nextVC.delegate = self
        }
    }
    
    func userDidUpdateNote(_noteTitle: NSString, _noteText: NSString) {
        //println("note updated")
        
        navBar.topItem?.title = _noteTitle as String
        noteText.text = _noteText as String
        
        noteTitle = _noteTitle as String
        noteData = _noteText as String
    }
    
    @IBAction func OpenNoteInMaps(sender: AnyObject) {
        
        let noteCoordinate = CLLocationCoordinate2DMake(latitude, longitude)
        let notePlacemark = MKPlacemark(coordinate: noteCoordinate, addressDictionary: nil)
        let noteItemOnMap = MKMapItem(placemark: notePlacemark)
        
        noteItemOnMap.name = noteTitle
        noteItemOnMap.openInMapsWithLaunchOptions(nil)
    }
}
