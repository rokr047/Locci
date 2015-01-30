//
//  HomeScreenViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/18/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class HomeScreenViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    var locationManager: CLLocationManager!
    
    @IBOutlet weak var notesTable: UITableView!
    
    var tableData: Array<AnyObject> = []
    
    //Location Information
    var locInfo: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //Load location information... and cache it in locInfo.
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to store notes & be notified about notes near you, please open this app's settings and set location access to 'Always'.",
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
        
        notesTable.rowHeight = 50
        //notesTable.backgroundView = UIImageView(image: UIImage(named: "bg4"))
    }
    
    override func viewDidAppear(animated: Bool) {
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let fRequest = NSFetchRequest(entityName: "Notes")
        fRequest.returnsObjectsAsFaults = false
        
        tableData = context.executeFetchRequest(fRequest, error: nil)!
        
        self.notesTable.reloadData()
        
        //println("found \(tableData.count) notes")
        
        if(!locInfo.isEmpty) {
            println("Stopping location update")
            self.locationManager.stopUpdatingLocation()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("noteCell", forIndexPath: indexPath) as UITableViewCell
        
        //Setting opacity for odd and even rows
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = UIColor.clearColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(2.0)
            cell.textLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
            cell.detailTextLabel?.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.0)
        }
        
        cell.textLabel?.font = UIFont(name: "Avenir Light", size: 16)
        cell.detailTextLabel?.font = UIFont(name: "Avenir Light", size: 10)
        
        if tableData.count == 0 {
            return cell
        }

        var data = tableData[indexPath.row] as Notes
        
        cell.textLabel?.text = data.title
        cell.detailTextLabel?.text = data.locationname
        
        //cell.textLabel?.textColor = UIColor.orangeColor()
        //cell.detailTextLabel?.textColor = UIColor.blueColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            let context: NSManagedObjectContext = appDelegate.managedObjectContext!
            
            context.deleteObject(tableData[indexPath.row] as NSManagedObject)
            tableData.removeAtIndex(indexPath.row)
            context.save(nil)
            
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        //var rowData = tableData[indexPath.row] as Notes
        
        /*
        var alert: UIAlertView = UIAlertView()
        alert.title = "\(rowData.title)"
        alert.message = "\(rowData.noteid) \(rowData.text) \(rowData.locationname) \(rowData.latitude) \(rowData.longitude)"
        alert.addButtonWithTitle("Ok")
        alert.show()
        */
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ViewNoteSegue" {
            var nextVC: ViewNoteViewController = segue.destinationViewController as ViewNoteViewController
            
            var selectedRowIndex = self.notesTable.indexPathForSelectedRow()
            var rowData = tableData[selectedRowIndex!.row] as Notes
            nextVC.noteId = rowData.noteid
            nextVC.noteData = rowData.text
            nextVC.noteTitle = rowData.title
            nextVC.locationName = rowData.locationname
            nextVC.latitude = rowData.latitude
            nextVC.longitude = rowData.longitude
            
            var selectedNote: NSManagedObject = tableData[selectedRowIndex!.row] as NSManagedObject
            nextVC.selectedNote = selectedNote
        }
    }
    
    @IBAction func ShareCurrentLocation(sender: AnyObject) {
        
        //Handle Disable of location data
        switch CLLocationManager.authorizationStatus() {
        case .Authorized, .AuthorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .NotDetermined:
            locationManager.requestAlwaysAuthorization()
        case .Restricted, .Denied:
            let alertController = UIAlertController(
                title: "Location Access Disabled",
                message: "In order to store notes & be notified about notes near you, please open this app's settings and set location access to 'Always'.",
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
        
        var alertController = UIAlertController(title: "You are Here", message: locInfo, preferredStyle: UIAlertControllerStyle.Alert)
        
        var okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.Default, handler: nil)
        
        var shareAction = UIAlertAction(title: "share", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            //println("launching share options...")
            
            let textToShare = "I am here : \(self.locInfo)\nsent via #Locci"
            
            let objectsToShare = [textToShare]
            
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList, UIActivityTypeSaveToCameraRoll]
            
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
        
        alertController.addAction(okAction)
        alertController.addAction(shareAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        locationManager.stopUpdatingLocation()
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
            var locationName = (containsPlacemark.name != nil) ? containsPlacemark.name : ""
            locInfo = locationName
            locInfo = (containsPlacemark.locality != nil) ? ("\(locInfo), \(containsPlacemark.locality)") : "\(locInfo)"
            locInfo = (containsPlacemark.subAdministrativeArea != nil) ? ("\(locInfo), \(containsPlacemark.subAdministrativeArea)") : "\(locInfo)"
            locInfo = (containsPlacemark.administrativeArea != nil) ? ("\(locInfo), \(containsPlacemark.administrativeArea)") : "\(locInfo)"
            locInfo = (containsPlacemark.postalCode != nil) ? ("\(locInfo) \(containsPlacemark.postalCode)") : "\(locInfo)"
            locInfo = (containsPlacemark.country != nil) ? ("\(locInfo), \(containsPlacemark.country)") : "\(locInfo)"
            
            let curLocation: CLLocation = containsPlacemark.location
            locInfo = "\(locInfo) \nlat : \(curLocation.coordinate.latitude) \nlong : \(curLocation.coordinate.longitude)"
        }
        
    }
}
