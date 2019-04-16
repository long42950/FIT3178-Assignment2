//
//  Task.swift
//  Assignment 2
//
//  Created by Chak Lee on 16/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import Foundation

class Task: NSObject {
    var taskTitle: String?
    var taskDescription: String?
    var dueDate: Date?
    var isCompleted: Bool?
    var errorMsg: String?
    
    func setTaskTitle(newTaskTitle: String) {
        taskTitle = newTaskTitle
    }
    
    func setTaskDescription(newTaskDescription: String) {
        taskDescription = newTaskDescription
    }
    
    func setDueDate(newDueDate: Date) {
        dueDate = newDueDate
    }
    
    func setCompletitionStatus(newStatus: Bool) {
        isCompleted = newStatus
    }
    
    func toString() -> String {
        var rtnValue: String = "\(String(describing: taskTitle)): \(String(describing: taskDescription)) "
        if(isCompleted!) {
            rtnValue += "Task has been completed"
        }
        else {
            rtnValue += "Must be completed by: \(String(describing: dueDate))"
        }
        return rtnValue
    }
    
}
