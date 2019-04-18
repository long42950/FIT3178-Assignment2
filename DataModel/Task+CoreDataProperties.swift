//
//  Task+CoreDataProperties.swift
//  Assignment 2
//
//  Created by Chak Lee on 18/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var taskTitle: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var dueDate: NSDate?
    @NSManaged public var isCompleted: Bool

}
