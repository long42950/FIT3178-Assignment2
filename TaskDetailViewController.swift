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
    
    func removeTask() {
        //unused
        }
    
    func taskIsEdited(task: Task) {
        self.task = task
        self.enrichLabel()
        if task.isCompleted {
            taskDelegate!.removeTask()
        }
    }
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTaskSegue" {
            let destination = segue.destination as! addEditTaskViewController
            destination.editTask = task
            destination.taskDelegate = self
        }
    }

}
