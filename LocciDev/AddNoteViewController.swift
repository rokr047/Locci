//
//  AddNoteViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/19/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class AddNoteViewController: UIViewController, MKMapViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, NoteEnteredDelegate {

    // Map
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    var locationName: String = ""
    
    //Texts, Labels & Buttons
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblLatLong: UILabel!
    
    //Alert Modal Window
    var overlayView: UIView!
    var alertView: UIView!
    var animator: UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    
    //Alert window information
    let alertWidth: CGFloat = 250
    let alertHeight: CGFloat = 150
    
    //The alert label
    var txtAlert = UILabel()
    
    //Location Data
    var curLatitude: Double = 0.0
    var curLongitude: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //GUI stuff
        //btnSave.layer.cornerRadius = 15.0
        //btnCancel.layer.cornerRadius = 15.0
        //txtNote.layer.cornerRadius = 15.0
        
        self.txtTitle.delegate = self
        
        // Initialize the animator
        animator = UIDynamicAnimator(referenceView: view)
        
        // Create the dark background view and the alert view
        fnCreateOverlay()
        fnCreateAlert()
        
        //Check if the app can use location data

        //Set up Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        
        //Handle Disable of location data
        switch CLLocationManager.authorizationStatus() {
        case .Authorized:
            locationManager.startUpdatingLocation()
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .AuthorizedWhenInUse, .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Background Location Access Disabled",
                message: "In order to be notified about notes near you, please open this app's settings and set location access to 'Always'.",
                preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let openAction = UIAlertAction(title: "Open Settings", style: .Default) { (action) in
                if let url = NSURL(string:UIApplicationOpenSettingsURLString) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
            alertController.addAction(openAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
            self.navigationController?.popViewControllerAnimated(false)
        }
        
        //Set up Map View
        mapView.delegate = self
        mapView.mapType = MKMapType.Standard
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("fnHandleTapGestureOnTextNote:"))
        txtNote.addGestureRecognizer(tapGesture)
        
        
    }
    
    func fnHandleTapGestureOnTextNote(tapGesture: UITapGestureRecognizer) {
        //println("tap.")
        /* Redacted Code
        //let vcEditNote = self.storyboard?.instantiateViewControllerWithIdentifier("vcEditNote") as EditNoteViewController
        
        //presentingViewController?.modalInPopover = true
        //presentViewController(vcEditNote, animated: true, completion: nil)
        */
        
        //Trigger segue via code
        self.performSegueWithIdentifier("EditNoteSegue", sender: nil)
    }
    
    // http://www.sitepoint.com/using-uikit-dynamics-swift-animate-apps
    func fnCreateOverlay() {
        // Create a gray view and set its alpha to 0 so it isn't visible
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.blackColor()
        overlayView.alpha = 0.0
        view.addSubview(overlayView)
    }
    
    func fnCreateAlert() {
        // Here the red alert view is created. It is created with rounded corners and given a shadow around it
        let alertViewFrame: CGRect = CGRectMake(0, 0, alertWidth, alertHeight)
        alertView = UIView(frame: alertViewFrame)
        alertView.backgroundColor = UIColor.whiteColor()
        alertView.alpha = 0.0
        alertView.layer.cornerRadius = 10;
        alertView.layer.shadowColor = UIColor.blackColor().CGColor;
        alertView.layer.shadowOffset = CGSizeMake(0, 5);
        alertView.layer.shadowOpacity = 0.3;
        alertView.layer.shadowRadius = 10.0;
        
        // Create a button and set a listener on it for when it is tapped. Then the button is added to the alert view
        let btnDismiss = UIButton.buttonWithType(UIButtonType.System) as UIButton
        btnDismiss.setTitle("dismiss", forState: UIControlState.Normal)
        btnDismiss.backgroundColor = UIColor.darkGrayColor()
        btnDismiss.frame = CGRectMake(0, 0, alertWidth, 40.0)
        btnDismiss.titleLabel!.font = UIFont(name: "Avenir Next Ultra Light", size: 25.0)
        
        //Alert text information
        txtAlert.text = "Lorum Ipsum"
        txtAlert.textColor = UIColor.redColor()
        txtAlert.frame = CGRectMake(0, 40.0, alertWidth, alertHeight-40.0)
        txtAlert.textAlignment = NSTextAlignment.Center
        txtAlert.font = UIFont(name: "Avenir Next Ultra Light", size: 16.0)
        txtAlert.numberOfLines = 0
        txtAlert.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        btnDismiss.addTarget(self, action: Selector("fnDismissAlert"), forControlEvents: UIControlEvents.TouchUpInside)
        
        alertView.addSubview(btnDismiss)
        alertView.addSubview(txtAlert)
        view.addSubview(alertView)
    }
    
    func fnShowAlert(_text: String) {
        // When the alert view is dismissed, I destroy it, so I check for this condition here
        // since if the Show Alert button is tapped again after dismissing, alertView will be nil
        // and so should be created again
        if (alertView == nil) {
            fnCreateAlert()
        }
        
        // I create the pan gesture recognizer here and not in ViewDidLoad() to
        // prevent the user moving the alert view on the screen before it is shown.
        // Remember, on load, the alert view is created but invisible to user, so you
        // don't want the user moving it around when they swipe or drag on the screen.
        //fnCreateGestureRecognizer()
        
        animator.removeAllBehaviors()
        
        // Animate in the overlay
        UIView.animateWithDuration(0.4) {
            self.overlayView.alpha = 0.5
        }
        
        //Set alert text
        txtAlert.text = _text
        
        // Animate the alert view using UIKit Dynamics.
        alertView.alpha = 1.0
        
        var snapBehaviour: UISnapBehavior = UISnapBehavior(item: alertView, snapToPoint: view.center)
        animator.addBehavior(snapBehaviour)
    }
    
    func fnDismissAlert() {
        
        animator.removeAllBehaviors()
        
        var gravityBehaviour: UIGravityBehavior = UIGravityBehavior(items: [alertView])
        gravityBehaviour.gravityDirection = CGVectorMake(0.0, 10.0);
        animator.addBehavior(gravityBehaviour)
        
        // This behaviour is included so that the alert view tilts when it falls, otherwise it will go straight down
        var itemBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [alertView])
        itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), forItem: alertView)
        animator.addBehavior(itemBehaviour)
        
        // Animate out the overlay, remove the alert view from its superview and set it to nil
        // If you don't set it to nil, it keeps falling off the screen and when Show Alert button is
        // tapped again, it will snap into view from below. It won't have the location settings we defined in createAlert()
        // And the more it 'falls' off the screen, the longer it takes to come back into view, so when the Show Alert button
        // is tapped again after a considerable time passes, the app seems unresponsive for a bit of time as the alert view
        // comes back up to the screen
        UIView.animateWithDuration(0.4, animations: {
            self.overlayView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.alertView.removeFromSuperview()
                self.alertView = nil
        })
    }
    
    func fnCreateGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("fnHandlePan:"))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    // This gets called when a pan gesture is recognized. It was set as the selector for the UIPanGestureRecognizer in the
    // createGestureRecognizer() function
    // We check for different states of the pan and do something different in each state
    // In Began, we create an attachment behaviour. We add an offset from the center to make the alert view twist in the
    // the direction of the pan
    // In Changed we set the attachment behaviour's anchor point to the location of the user's touch
    // When the user stops dragging (In Ended), we snap the alert view back to the view's center (which is where it was originally located)
    // When the user drags the view too far down, we dismiss the view
    // I check whether the alert view is not nil before taking action. This ensures that when the user dismisses the alert view
    // and drags on the screen, the app will not crash as it tries to move a view that hasn't been initialized.
    func fnHandlePan(sender: UIPanGestureRecognizer) {
        
        if (alertView != nil) {
            let panLocationInView = sender.locationInView(view)
            let panLocationInAlertView = sender.locationInView(alertView)
            
            if sender.state == UIGestureRecognizerState.Began {
                animator.removeAllBehaviors()
                
                let offset = UIOffsetMake(panLocationInAlertView.x - CGRectGetMidX(alertView.bounds), panLocationInAlertView.y - CGRectGetMidY(alertView.bounds));
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                animator.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizerState.Changed {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if sender.state == UIGestureRecognizerState.Ended {
                animator.removeAllBehaviors()
                
                snapBehavior = UISnapBehavior(item: alertView, snapToPoint: view.center)
                animator.addBehavior(snapBehavior)
                
                if sender.translationInView(view).y > 100 {
                    fnDismissAlert()
                }
            }
        }
    }
    
    //Delegate method that gets the note data from modal view
    func userDidEnterNote(noteText: NSString) {
        println("note entered")
        txtNote.text = noteText
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditNoteSegue" {
            let noteVC: EditNoteViewController = segue.destinationViewController as EditNoteViewController
            
            noteVC.delegate = self
            
            if txtNote.text != "click here to enter your note" {
                noteVC.currentNote = txtNote.text
            }
        }
    }
    @IBAction func CreateNote(sender: AnyObject) {
        //Show alerts messages for incorrect or missing data
        var aText = ""
        var isMissingEntry = false
        
        if txtTitle.text.isEmpty {
            aText = "you are missing a title for your note"
            isMissingEntry = true
        }
        
        if  txtNote.text.isEmpty || txtNote.text.compare("touch here to enter your note", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil, locale: nil) == NSComparisonResult.OrderedSame {
            if !aText.isEmpty {
                aText = aText + " and "
            }
            aText = aText + "you have not entered your note yet."
            isMissingEntry = true
        }
        
        if isMissingEntry {
            fnShowAlert(aText)
            return
        }
        
        //Code to save the note info to CoreData
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        //let _entity = NSEntityDescription.entityForName("Notes", inManagedObjectContext: context)
        
        var newNote = NSEntityDescription.insertNewObjectForEntityForName("Notes", inManagedObjectContext: context) as Notes
        
        //Need to get the current count to set the new noteid value
        let fRequest = NSFetchRequest(entityName: "Notes")
        let recordCount = appDelegate.managedObjectContext?.countForFetchRequest(fRequest, error: nil)
        
        //var newNote = Notes(entity: _entity!, insertIntoManagedObjectContext: context)
        newNote.noteid = recordCount! + 0
        newNote.title = txtTitle.text
        newNote.text = txtNote.text
        newNote.latitude = curLatitude
        newNote.longitude = curLongitude
        newNote.locationname = locationName
        
        context.save(nil) //TODO NSErrorPointer error handling
        locationManager.stopUpdatingLocation()
        println("note saved")
        
        //Go back to home screen
        navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func AddNote(sender: UIButton) {        
        //Dummy Code. Needs to be removed.
    }
    
    @IBAction func CancelNote(sender: AnyObject) {
        
        println("note canceled")
        //Go back to home screen
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    //Location Manager functions that gets back reverseGeoDecoded location data
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location " + error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: {(placemarks, error)->Void in
            
            if (error != nil) {
                println("Reverse geocoder failed with error" + error.localizedDescription)
                return
            }
            
            if placemarks.count > 0 {
                let pm = placemarks[0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                println("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            //stop updating location to save battery life
            //locationManager.stopUpdatingLocation()
            
            //Location Information
            var locInfo: String = ""
            
            locationName = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            locInfo = locationName
            locInfo = (containsPlacemark.locality != nil) ? ("\(locInfo), \(containsPlacemark.locality)") : "\(locInfo)"
            locInfo = (containsPlacemark.subAdministrativeArea != nil) ? ("\(locInfo), \(containsPlacemark.subAdministrativeArea)") : "\(locInfo)"
            locInfo = (containsPlacemark.administrativeArea != nil) ? ("\(locInfo), \(containsPlacemark.administrativeArea)") : "\(locInfo)"
            locInfo = (containsPlacemark.postalCode != nil) ? ("\(locInfo) \(containsPlacemark.postalCode)") : "\(locInfo)"
            locInfo = (containsPlacemark.country != nil) ? ("\(locInfo), \(containsPlacemark.country)") : "\(locInfo)"

            lblLocation.text = locInfo
            
            let curLocation: CLLocation = containsPlacemark.location
            lblLatLong.text = "\(curLocation.coordinate.latitude) , \(curLocation.coordinate.longitude)"
            
            curLatitude = curLocation.coordinate.latitude as Double
            curLongitude = curLocation.coordinate.longitude as Double
        }
        
    }
}
