//
//  CompletedTaskTableViewController.swift
//  Assignment 2
//
//  Created by Chak Lee on 17/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class CompletedTaskTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener, TaskDelegate {
    
    //section indicator for task cells
    let SECTION_TASKS = 0;
    
    //indicator for task cell
    let TASK_CELL = "completedTaskCell"
    
    //current date
    let TODAY = Date()
    
    //the local completed task list
    var allTasks: [Task] = []
    
    //the local filtered completed task list
    var filteredTasks: [Task] = []
    
    //databaseController for this page
    weak var databaseController: DatabaseProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        //set up the database controller in this page
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        
        //create a searchController instance for the search bar
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    //this method will add this page's listener to the listener list
    //when appear on the screen
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        self.tableView.reloadData()
        
        
        
    }
    
    //this method will remove this page's listener from the listener list
    //when disappear on the screen
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    //setup the listenerType to tasks
    var listenerType = ListenerType.tasks
    
    
    //clean up the local task list, refresh it with what's fetched from the
    //container
    func onTaskListChange(change: DatabaseChange, tasks: [Task]) {
        allTasks = []
        for task in tasks {
            //only include tasks that is completed
            if task.isCompleted {
                allTasks.append(task)
            }
        }
        //enrich the filter list with the full list
        filteredTasks = allTasks
        updateSearchResults(for: navigationItem.searchController!)
    }
    
    //update the list everytime the user type in new requirement
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text?.lowercased(), searchText.count > 0 {
            filteredTasks = allTasks.filter({(task: Task) -> Bool in
                return task.taskTitle!.lowercased().contains(searchText)
            })
        }
        else {
            filteredTasks = allTasks
        }
        
        tableView.reloadData();
    }
    // MARK: - Table view data source

    //define the number of section
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    //define the number of row in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }

    //define what information is shown on the label
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskCell = tableView.dequeueReusableCell(withIdentifier: TASK_CELL, for: indexPath)
            as! CompletedTaskTableViewCell
        let task = filteredTasks[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_AU")
        
        taskCell.titleLabel.text = task.taskTitle

        return taskCell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    //refresh the list
    func refreshTaskList() {
        tableView.reloadData()
        
    }
    
    //not used here
    func taskIsEdited(task: Task) {
        //unused
    }

    //disable edit action for status cell and enable for task cell
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .normal, title: "delete", handler: { action, index in
            let deleteTask = self.filteredTasks[indexPath.row]
            self.allTasks.remove(at: indexPath.row)
            self.filteredTasks.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
            let _ = self.databaseController?.deleteTask(task: deleteTask)
            
            
        })
        delete.backgroundColor = .red
        
        return [delete]
    }
    
    // MARK: - Navigation

    //this will help sending the task's value to the task detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "viewCompletedTaskSegue" {
            let destination = segue.destination as! TaskDetailViewController
            destination.task = filteredTasks[self.tableView.indexPathForSelectedRow!.row]
            destination.taskDelegate = self
            
        }
    }
    

}
