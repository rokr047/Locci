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

class AddNoteViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var txtNote: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the map
        locationManager = CLLocationManager()
        locationManager.requestAlwaysAuthorization()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        btnSave.layer.cornerRadius = 15.0
        btnCancel.layer.cornerRadius = 15.0
        
        txtNote.layer.cornerRadius = 15.0
        
        var tapGesture = UITapGestureRecognizer(target: self, action: Selector("fnHandleTapGestureOnTextNote:"))
        txtNote.addGestureRecognizer(tapGesture)
        
    }
    
    func fnHandleTapGestureOnTextNote(tapGesture: UITapGestureRecognizer) {
        println("tap.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
