//
//  HomeScreenViewController.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/18/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit
import MapKit

class HomeScreenViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    var locationManager: CLLocationManager!
    
    @IBOutlet weak var notesTable: UITableView!
    
    //TableView Test
    var testData: Array<AnyObject> = []
    var testDetailData: Array<AnyObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        //TableView Test
        testData = ["Home", "Walmart", "Apple Work", "Microsoft", "Dropbox", "Twitter", "Electronic Arts", "Rockstar", "Ubisoft", "Zynga", "Scopely", "Imangi", "Backflip", "Valve", "Amazon", "Flipkart"]
        
        testDetailData = ["2200 Monroe St", "1208 Jackson Ave", "Apple Inc.", "Microsoft", "Dropbox", "Twitter", "Electronic Arts", "Rockstar", "Ubisoft", "Zynga", "Scopely", "Imangi", "Backflip", "Valve", "Amazon", "Flipkart"]
        
        notesTable.rowHeight = 50
        //notesTable.backgroundView = UIImageView(image: UIImage(named: "bg4"))
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
        return testData.count
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
        
        cell.textLabel?.text = testData[indexPath.row] as? String
        cell.detailTextLabel?.text = testDetailData[indexPath.row] as? String
        
        //cell.textLabel?.textColor = UIColor.whiteColor()
        //cell.detailTextLabel?.textColor = UIColor.whiteColor()
        
        cell.textLabel?.font = UIFont(name: "Avenir Light", size: 20)
        cell.detailTextLabel?.font = UIFont(name: "Avenir Light", size: 12)
        
        return cell
    }
}
