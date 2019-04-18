//
//  CoreDataController.swift
//  Assignment 2
//
//  Created by Chak Lee on 18/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, NSFetchedResultsControllerDelegate, DatabaseProtocol {
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistantContainer: NSPersistentContainer
    
    var allTasksFetchedResultsController: NSFetchedResultsController<Task>?
    
    override init() {
        persistantContainer = NSPersistentContainer(name: "Tasks")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()
        
        if fetchAllTasks().count == 0 {
            createDefaultEntries()
        }
    }
    
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    func addTask(title: String, des: String, due: Date, completed: Bool) -> Task {
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: persistantContainer.viewContext)
        as! Task
        task.taskTitle = title
        task.taskDescription = des
        task.dueDate = due as NSDate
        task.isCompleted = completed
        saveContext()
        return task
    }
    
    func deleteTask(task: Task) {
        persistantContainer.viewContext.delete(task)
        saveContext()
    }
    
    func markAsCompleted(row: Int) {
        
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == ListenerType.tasks {
            listener.onTaskListChange(change: .delete, tasks: fetchAllTasks())
            //print(fetchAllTasks())
            
        }
    }
    
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    func fetchAllTasks() -> [Task] {
        if allTasksFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let titleSortDescriptor = NSSortDescriptor(key: "taskTitle", ascending: true)
            fetchRequest.sortDescriptors = [titleSortDescriptor]
            allTasksFetchedResultsController = NSFetchedResultsController<Task>(fetchRequest: fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allTasksFetchedResultsController?.delegate = self
            
            do {
                try allTasksFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        var tasks = [Task]()
        if allTasksFetchedResultsController?.fetchedObjects != nil {
            tasks = (allTasksFetchedResultsController?.fetchedObjects)!
        }
        
        return tasks
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allTasksFetchedResultsController {
            listeners.invoke { (listener) in if listener.listenerType == ListenerType.tasks {
                listener.onTaskListChange(change: .edit, tasks: fetchAllTasks())
                }
            }
        }

    }
    
    func createDefaultEntries() {
        let _ = addTask(title: "Task1", des: "1", due: Date(), completed: false)
        let _ = addTask(title: "Task2", des: "2", due: Date(), completed: false)
        let _ = addTask(title: "Task3", des: "3", due: Date(), completed: false)
        let _ = addTask(title: "Task4", des: "4", due: Date(), completed: false)
        let _ = addTask(title: "Task5", des: "5", due: Date().addingTimeInterval(-100000000), completed: false)
        
    }
}
