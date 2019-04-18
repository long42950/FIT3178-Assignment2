//
//  AllTasksTableViewController.swift
//  Assignment 2
//
//  Created by Chak Lee on 16/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class AllTasksTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener, TaskDelegate{
    
    //section indicator for task cells
    let SECTION_TASKS = 0;
    
    //section indicator for status cell
    let SECTION_STATUS = 1;
    
    //indicator for task cell
    let TASK_CELL = "taskCell"
    
    //indicator for status cell
    let STATUS_CELL = "taskNumCell"
    
    //current date
    let TODAY = Date()
    
    //the local task list
    var allTasks: [Task] = []
    
    //the local filtered task list
    var filteredTasks: [Task] = []
    
    //databaseController for this page
    weak var databaseController: DatabaseProtocol?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController

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
            if !task.isCompleted {
                allTasks.append(task)
            }
        }
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    //define the number of row in a section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //exclude completed task
        if section == SECTION_TASKS {
            return filteredTasks.count
        }
        else {
            return 1
        }
    }

    
    //define what information is shown on the label
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_TASKS {
            let taskCell = tableView.dequeueReusableCell(withIdentifier: TASK_CELL, for: indexPath)
            as! TaskTableViewCell
            let task = filteredTasks[indexPath.row]
            
            //dateFormatter is used for comparing date with the tasks
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_AU")
            
            taskCell.nameLabel.text = task.taskTitle
            taskCell.dueDateLabel.text = dateFormatter.string(from: task.dueDate! as Date)
            
            
            //change due date color according to priority
            let components = Calendar.current.dateComponents([.day], from: task.dueDate! as Date, to: TODAY)
            let color: UIColor?
            
            if components.day == 0 {
                // show orange text
                taskCell.dueDateLabel.text = "Today!"
                color = UIColor.orange
            }
            else if components.day! < 0 {
                //show green text
                color = UIColor.green
            }
            else if TODAY > task.dueDate! as Date {
                //show red text
                color = UIColor.red
            }
            else {
                color = UIColor.gray
            }
            taskCell.dueDateLabel.textColor = color!
            
            return taskCell
        }
        
        //FREE BIRD!!!!
        let statusCell = tableView.dequeueReusableCell(withIdentifier: STATUS_CELL, for: indexPath) as! TaskStatusTableViewCell
        let color: UIColor = .red
        if allTasks.count == 0 {
            statusCell.statusLabel?.text = "Free like FreeBird🐦"
            statusCell.taskNumLabel?.text = ""
        }
        else {
        statusCell.statusLabel?.text = " more task(s) to go"
        
        //give the number color
        statusCell.taskNumLabel?.text = "\(allTasks.count)"
        statusCell.taskNumLabel?.textColor = color
        }
        statusCell.selectionStyle = .none
        
        return statusCell
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
    //this serves as the way to delete and mark task as completed
    //to perform the above actions swipe the task cell to the left
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == SECTION_STATUS {
            return []
        }
        
        let done = UITableViewRowAction(style: .normal, title: "done", handler: { action, index in
            let completedTask = self.filteredTasks[indexPath.row]
            //self.allTasks[indexPath.row].isCompleted = true
            self.allTasks.remove(at: indexPath.row)
            self.filteredTasks.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
            let _ = self.databaseController?.markAsCompleted(task: completedTask)

        })
        done.backgroundColor = .blue
        
        let delete = UITableViewRowAction(style: .normal, title: "delete", handler: { action, index in
            let deleteTask = self.filteredTasks[indexPath.row]
            self.allTasks.remove(at: indexPath.row)
            self.filteredTasks.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            let _ = self.databaseController?.deleteTask(task: deleteTask)
            
            
        })
        delete.backgroundColor = .red
        
        return [done, delete]
    }

    //define titles for each section
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String{
        if section == SECTION_TASKS {
            return "Task and due date"
        }
        else {
            return "List report"
        }
    }
    
    //this will help sending the task's value to the task detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewTaskSegue" {
            let destination = segue.destination as! TaskDetailViewController
            destination.task = filteredTasks[self.tableView.indexPathForSelectedRow!.row]
            destination.taskDelegate = self
            //filteredTasks[1].objectID
        }
    }

}
