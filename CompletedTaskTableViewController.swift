//
//  CompletedTaskTableViewController.swift
//  Assignment 2
//
//  Created by Chak Lee on 17/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class CompletedTaskTableViewController: UITableViewController, UISearchResultsUpdating, DatabaseListener, TaskDelegate {
    
    let SECTION_TASKS = 0;
    let TASK_CELL = "completedTaskCell"
    let TODAY = Date()
    var allTasks: [Task] = []
    var filteredTasks: [Task] = []
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.addListener(listener: self)
        self.tableView.reloadData()
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        databaseController?.removeListener(listener: self)
    }
    
    var listenerType = ListenerType.tasks
    
    
    func onTaskListChange(change: DatabaseChange, tasks: [Task]) {
        allTasks = []
        for task in tasks {
            if task.isCompleted {
                allTasks.append(task)
            }
        }
        filteredTasks = allTasks
        updateSearchResults(for: navigationItem.searchController!)
    }
    
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTasks.count
    }

    
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
    
    func removeTask() {
        //tableView.reloadData()
        //tableView.reloadSections(IndexSet(integer: 1), with: .none)
        
    }
    
    func taskIsEdited(task: Task) {
        //unused
    }

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
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

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
