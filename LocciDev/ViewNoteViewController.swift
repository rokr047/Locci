//
//  ViewNoteViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/24/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit
import MapKit

class ViewNoteViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    
    var noteId: integer_t = -1
    var noteTitle: String = ""
    var noteData: String = ""
    var locationName: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
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
        mapView.setRegion(regionToZoom, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func ShowActionSheet(sender: AnyObject) {
        //let actionTitle = "actions for current note"
        //let actionMessage = ""
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        let shareAction = UIAlertAction(title: "share", style: UIAlertActionStyle.Default, handler: fnShareActionHandler)
        let editAction = UIAlertAction(title: "edit", style: UIAlertActionStyle.Default, handler: fnEditActionHandler)
        let deleteAction = UIAlertAction(title: "delete", style: UIAlertActionStyle.Destructive, handler: fnDeleteActionHandler)
        let cancelAction = UIAlertAction(title: "cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        actionSheet.addAction(shareAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func fnShareActionHandler (action:UIAlertAction!) -> Void {
        println("Note will be shared.")
    }
    
    func fnEditActionHandler (action:UIAlertAction!) -> Void {
        println("Note will be edited.")
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
}
