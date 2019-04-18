//
//  DatabaseProtocol.swift
//  Assignment 2
//
//  Created by Chak Lee on 18/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import Foundation

enum DatabaseChange {
    case add
    case delete
    case edit
}

enum ListenerType {
    case tasks
}

protocol DatabaseListener: AnyObject {
    var listenerType: ListenerType {get set}
    
    //This method feeds all tasks to the local array when implemented in
    //both incompleted and completed task list
    func onTaskListChange(change: DatabaseChange, tasks: [Task])
}

protocol DatabaseProtocol: AnyObject {
    
    //create task in CoreData persistant storage
    func addTask(title: String, des: String, due: Date, completed: Bool) -> Task
    
    //delete a task in CoreData persistant storage
    func deleteTask(task: Task)
    
    //update a task's status to completed: (change isCompleted to true)
    func markAsCompleted(task: Task)
    
    //add a new screen's DatabaseListener to the listener list
    func addListener(listener: DatabaseListener)
    
    //remove a DatabaseListener from the listener list
    func removeListener(listener: DatabaseListener)
}
