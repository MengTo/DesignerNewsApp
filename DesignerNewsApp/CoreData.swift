//
//  CoreData.swift
//  DesignerNewsApp
//
//  Created by Meng To on 2015-01-12.
//  Copyright (c) 2015 Meng To. All rights reserved.
//

import UIKit
import CoreData

var dataTable = "User"
var dataKey = "token"

func saveToken(value: String) {
        
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let entity =  NSEntityDescription.entityForName(dataTable, inManagedObjectContext: managedContext)
    let row = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
    row.setValue(value, forKey: dataKey)
    
    var error: NSError?
    if !managedContext.save(&error) {
        println("Could not save \(error), \(error?.userInfo)")
    }
}

func deleteToken(row: Int) {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let request = NSFetchRequest(entityName:dataTable)
    var error: NSError?
    let results = managedContext.executeFetchRequest(request, error: &error) as [NSManagedObject]!
    
    managedContext.deleteObject(results[row])
    
    if !managedContext.save(&error) {
        println("Could not save \(error), \(error?.userInfo)")
    }
}

func getToken() -> String {
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    let managedContext = appDelegate.managedObjectContext!
    
    let request = NSFetchRequest(entityName:dataTable)
    var error: NSError?
    let results = managedContext.executeFetchRequest(request, error: &error) as [NSManagedObject]!
    
    var token = ""
    if results.count > 0 {
        token = results[0].valueForKey(dataKey) as String!
    }
    return token
}