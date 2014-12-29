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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
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
        
        println("found \(tableData.count) notes")
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
        
        //cell.textLabel?.textColor = UIColor.whiteColor()
        //cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Get the row data for the selected row
        var rowData = tableData[indexPath.row] as Notes
        
        var alert: UIAlertView = UIAlertView()
        alert.title = "\(rowData.title)"
        alert.message = "\(rowData.noteid) \(rowData.text) \(rowData.locationname) \(rowData.latitude) \(rowData.longitude)"
        alert.addButtonWithTitle("Ok")
        alert.show()
        
        let vcViewNote = self.storyboard?.instantiateViewControllerWithIdentifier("vcViewNote") as ViewNoteViewController
        self.navigationController?.pushViewController(vcViewNote, animated: true)
    }
}
