//
//  CustomAnnotation.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 1/4/15.
//  Copyright (c) 2015 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit
import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: NSString
    var subtitle: NSString
    
    init(coordinate: CLLocationCoordinate2D, title: NSString, subtitle: NSString) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
    }
}
