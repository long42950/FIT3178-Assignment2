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
    //func onEdit (change: DatabaseChange, task: Task)
    func onTaskListChange(change: DatabaseChange, tasks: [Task])
}

protocol DatabaseProtocol: AnyObject {
    
    func addTask(title: String, des: String, due: Date, completed: Bool) -> Task
    func deleteTask(task: Task)
    func markAsCompleted(task: Task)
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
}
