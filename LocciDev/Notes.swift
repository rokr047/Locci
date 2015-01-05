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
    class func DeleteNote(id: integer_t) -> Bool {
        
        var status: Bool = false
        
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let context: NSManagedObjectContext = appDelegate.managedObjectContext!
        
        let predicate = NSPredicate(format: "noteid = %d", id)
        
        let fRequest = NSFetchRequest(entityName: "Notes")
        fRequest.returnsObjectsAsFaults = false
        fRequest.predicate = predicate
        
        var tableData = context.executeFetchRequest(fRequest, error: nil)!
        
        if tableData.count > 0 {
            context.deleteObject(tableData[0] as NSManagedObject)
            context.save(nil)
            status = true
        }
        
        return status
    }
}
