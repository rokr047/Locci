//
//  Notes.swift
//  Locci
//
//  Created by Karthikeyan Sreenivasan on 12/25/14.
//  Copyright (c) 2014 Karthikeyan Sreenivasan. All rights reserved.
//

import UIKit
import Foundation
import CoreData

@objc(Notes)
class Notes: NSManagedObject {
   
    @NSManaged var noteid: integer_t
    @NSManaged var title: String
    @NSManaged var text: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var locationname: String
    
    //TODO Add more functions here to enhance functionality later
    
}
