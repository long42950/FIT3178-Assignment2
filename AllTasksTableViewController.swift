//
//  AllTasksTableViewController.swift
//  Assignment 2
//
//  Created by Chak Lee on 16/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class AllTasksTableViewController: UITableViewController, UISearchResultsUpdating, AddTaskDelegate{
    
    let SECTION_TASKS = 0;
    let SECTION_STATUS = 1;
    let TASK_CELL = "taskCell"
    let STATUS_CELL = "taskNumCell"
    var allTasks: [Task] = []
    var filteredTasks: [Task] = []
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testMethod()
        
        filteredTasks = allTasks

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
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
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == SECTION_TASKS {
            return filteredTasks.count
        }
        else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var test: Int = indexPath.section
        
        if indexPath.section == 0 {
            let taskCell = tableView.dequeueReusableCell(withIdentifier: TASK_CELL, for: indexPath)
            as! TaskTableViewCell
            let task = filteredTasks[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_AU")
            
            taskCell.nameLabel.text = task.taskTitle
            taskCell.dueDateLabel.text = dateFormatter.string(from: task.dueDate!)
            
            return taskCell
        }
        
        let statusCell = tableView.dequeueReusableCell(withIdentifier: STATUS_CELL, for: indexPath) as! TaskStatusTableViewCell
        statusCell.statusLabel?.text = "\(allTasks.count) more task(s) to go"
        statusCell.selectionStyle = .none
        return statusCell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func testMethod() {
        allTasks.append(Task(title: "Task1", des: "1", due: Date()))
        allTasks.append(Task(title: "Task2", des: "2", due: Date()))
        allTasks.append(Task(title: "Task3", des: "3", due: Date()))
        allTasks.append(Task(title: "Task4", des: "4", due: Date()))
        allTasks.append(Task(title: "Task5", des: "5", due: Date()))
    }
    
    func addTask(newTask: Task) -> Bool {
        allTasks.append(newTask)
        filteredTasks.append(newTask)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: <#T##Int#>, section: <#T##Int#>)], with: <#T##UITableView.RowAnimation#>)
    }

}
