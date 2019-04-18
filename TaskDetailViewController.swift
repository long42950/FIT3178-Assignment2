//
//  TaskDetailViewController.swift
//  Assignment 2
//
//  Created by Chak Lee on 17/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class TaskDetailViewController: UIViewController, TaskDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var statLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    weak var taskDelegate: TaskDelegate?
    
    var task: Task?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.enrichLabel()
        // Do any additional setup after loading the view.
    }
    
    //an abstract method but not needed in the TaskDetailPage
    func refreshTaskList() {
        //unused
        }
    
    //if the task was edited refresh the page with new data and
    //notify the changes to either task list
    func taskIsEdited(task: Task) {
        self.task = task
        self.enrichLabel()
        if task.isCompleted {
            taskDelegate!.refreshTaskList()
        }
    }
    
    //this method will refresh the label with updated value
    func enrichLabel() {
        titleLabel.text = task!.taskTitle
        desLabel.text = task!.taskDescription
        if task!.isCompleted {
            statLabel.text = "Completed"
        }
        else {
            statLabel.text = "Incompleted"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "en_AU")
        dateLabel.text = dateFormatter.string(from: task!.dueDate! as Date)    }
    

    
    // MARK: - Navigation
    
    //this will help sending the task's value to the addEdit task page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTaskSegue" {
            let destination = segue.destination as! addEditTaskViewController
            destination.editTask = task
            destination.taskDelegate = self
        }
    }

}
