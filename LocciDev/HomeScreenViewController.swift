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
        testData = ["Apple", "Google", "Facebook", "Microsoft", "Dropbox", "Twitter", "Electronic Arts", "Rockstar", "Ubisoft", "Zynga", "Scopely", "Imangi", "Backflip", "Valve", "Amazon", "Flipkart"]
        
        testDetailData = ["Apple", "Google", "Facebook", "Microsoft", "Dropbox", "Twitter", "Electronic Arts", "Rockstar", "Ubisoft", "Zynga", "Scopely", "Imangi", "Backflip", "Valve", "Amazon", "Flipkart"]
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
        
        cell.textLabel?.text = testData[indexPath.row] as? String
        cell.detailTextLabel?.text = testData[indexPath.row] as? String
        
        return cell
    }
}
