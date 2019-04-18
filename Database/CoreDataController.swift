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
    
    //A constructor: link this variable with the container
    override init() {
        persistantContainer = NSPersistentContainer(name: "Tasks")
        persistantContainer.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        super.init()
        
        //Generate dummy data if the there are no task in the app at all
        if fetchAllTasks().count == 0 {
            createDefaultEntries()
        }
    }
    
    //try to save the changes made to the container
    func saveContext() {
        if persistantContainer.viewContext.hasChanges {
            do {
                try persistantContainer.viewContext.save()
            } catch {
                fatalError("Failed to save data to Core Data: \(error)")
            }
        }
    }
    
    //add new task
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
    
    //delete old task
    func deleteTask(task: Task) {
        persistantContainer.viewContext.delete(task)
        saveContext()
    }
    
    //mark a task as completed
    func markAsCompleted(task: Task) {
        task.setValue(true, forKey: "isCompleted")
        saveContext()
    }
    
    //add new DatabaseListener to the listener list
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        //if the changes to database are done by pages with the tasks ListenerType,
        //this method in those pages will be invoked
        if listener.listenerType == ListenerType.tasks {
            listener.onTaskListChange(change: .delete, tasks: fetchAllTasks())
            
        }
    }
    
    //remove a DatabaseListener from the listener list
    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
    
    //fetch all tasks from the container to caller as an array of Task
    func fetchAllTasks() -> [Task] {
        //if is fetching data for the first time, the controller needs to be configurated
        if allTasksFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
            let titleSortDescriptor = NSSortDescriptor(key: "taskTitle", ascending: true)
            fetchRequest.sortDescriptors = [titleSortDescriptor]
            allTasksFetchedResultsController = NSFetchedResultsController<Task>(fetchRequest: fetchRequest, managedObjectContext: persistantContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            allTasksFetchedResultsController?.delegate = self
            
            //try to fetch
            do {
                try allTasksFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Request failed: \(error)")
            }
        }
        
        //fetch and return the fetched data
        var tasks = [Task]()
        if allTasksFetchedResultsController?.fetchedObjects != nil {
            tasks = (allTasksFetchedResultsController?.fetchedObjects)!
        }
        
        return tasks
    }
    
    //when a controller make changes at the container and is fetching all tasks,
    //invoke the specified listener
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller == allTasksFetchedResultsController {
            listeners.invoke { (listener) in if listener.listenerType == ListenerType.tasks {
                listener.onTaskListChange(change: .edit, tasks: fetchAllTasks())
                }
            }
        }

    }
    
    //create some dummy data incase there's nothing in the app at all
    func createDefaultEntries() {
        let _ = addTask(title: "Buy Ice Cream", des: "Today is very hot", due: Date(), completed: false)
        let _ = addTask(title: "Body check", des: "I don't fell so good", due: Date().addingTimeInterval(264600), completed: false)
        let _ = addTask(title: "travel to Canada", des: "The view must be beautiful", due: Date().addingTimeInterval(3904900), completed: false)
        let _ = addTask(title: "Visit Dr.House", des: "It's not lupus", due: Date(), completed: false)
        let _ = addTask(title: "Buy a water bed", des: "Must be good", due: Date(), completed: true)
        let _ = addTask(title: "ZE event on GFL", des: "no Mako", due: Date().addingTimeInterval(430390), completed: true)
        let _ = addTask(title: "Finish Assignment 2", des: "this is so difficult :P", due: Date(), completed: true)
        let _ = addTask(title: "Buy groceries", des: "need more oranges", due: Date().addingTimeInterval(-100000), completed: true)
        let _ = addTask(title: "Watch Captain Marvel", des: "I love cats", due: Date().addingTimeInterval(-100000000), completed: false)
        
    }
}
