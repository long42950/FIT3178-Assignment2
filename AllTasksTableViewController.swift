//
//  AllTasksTableViewController.swift
//  Assignment 2
//
//  Created by Chak Lee on 16/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class AllTasksTableViewController: UITableViewController, UISearchResultsUpdating, TaskDelegate{
    
    let SECTION_TASKS = 0;
    let SECTION_STATUS = 1;
    let TASK_CELL = "taskCell"
    let STATUS_CELL = "taskNumCell"
    let TODAY = Date()
    var allTasks: [Task] = []
    var filteredTasks: [Task] = []
    var addTaskDelegate: TaskDelegate?
    

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
        var count: Int  = 0
        //exclude completed task
        if section == SECTION_TASKS {
            for task in allTasks {
                if !task.isCompleted! {
                    count += 1
                }
            }
            return count
        }
        else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == SECTION_TASKS {
            let taskCell = tableView.dequeueReusableCell(withIdentifier: TASK_CELL, for: indexPath)
            as! TaskTableViewCell
            let task = filteredTasks[indexPath.row]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            dateFormatter.locale = Locale(identifier: "en_AU")
            
            taskCell.nameLabel.text = task.taskTitle
            taskCell.dueDateLabel.text = dateFormatter.string(from: task.dueDate!)
            
            //change due date color according to priority
            
            let components = Calendar.current.dateComponents([.day], from: task.dueDate!, to: TODAY)
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
            else if TODAY > task.dueDate! {
                //show red text
                color = UIColor.red
            }
            else {
                color = UIColor.gray
            }
            taskCell.dueDateLabel.textColor = color!
            
            return taskCell
        }
        
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
    

    

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == SECTION_STATUS {
            return []
        }
        
        let done = UITableViewRowAction(style: .normal, title: "done", handler: { action, index in
            self.allTasks[indexPath.row].isCompleted = true
            self.allTasks.remove(at: indexPath.row)
            self.filteredTasks.remove(at: indexPath.row)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadData()
            
        })
        done.backgroundColor = .blue
        
        let delete = UITableViewRowAction(style: .normal, title: "delete", handler: { action, index in
            self.allTasks.remove(at: indexPath.row)
            self.filteredTasks.remove(at: indexPath.row)
            // Delete the row from the data source
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            
        })
        delete.backgroundColor = .red
        
        return [done, delete]
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

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String{
        if section == SECTION_TASKS {
            return "Task and due date"
        }
        else {
            return "List report"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func testMethod() {
        allTasks.append(Task(title: "Task1", des: "1", due: Date()))
        allTasks.append(Task(title: "Task2", des: "2", due: Date()))
        allTasks.append(Task(title: "Task3", des: "3", due: Date()))
        allTasks.append(Task(title: "Task4", des: "4", due: Date()))
        allTasks.append(Task(title: "Task5", des: "5", due: Date().addingTimeInterval(-100000000)))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createTaskSegue" {
            let destination = segue.destination as! addEditTaskViewController
            destination.taskDelegate = self
        }
        
        if segue.identifier == "viewTaskSegue" {
            let destination = segue.destination as! TaskDetailViewController
            destination.task = filteredTasks[self.tableView.indexPathForSelectedRow!.row]
        }    }
    
    func addTask(newTask: Task) -> Bool {
        allTasks.append(newTask)
        filteredTasks.append(newTask)
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: filteredTasks.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
        tableView.reloadSections([SECTION_STATUS], with: .automatic)
        return true
    }
    
    func removeTask(badTask: Task) -> Bool {
        return false
    }

}
