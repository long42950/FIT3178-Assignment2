//
//  AddTaskDelegate.swift
//  Assignment 2
//
//  Created by Chak Lee on 17/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import Foundation

protocol TaskDelegate: AnyObject {
    
    //what to do when a task was edited
    func taskIsEdited(task: Task)
    
    //the help reload a table's data
    func refreshTaskList()
}
