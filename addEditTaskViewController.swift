//
//  addEditTaskViewController.swift
//  Assignment 2
//
//  Created by Chak Lee on 16/4/19.
//  Copyright © 2019 Chak Lee. All rights reserved.
//

import UIKit

class addEditTaskViewController: UIViewController {

    @IBOutlet weak var newTaskTitle: UITextField!
    @IBOutlet weak var newTaskDescription: UITextField!
    @IBOutlet weak var newDueDate: UIDatePicker!
    @IBOutlet weak var newStatus: UISegmentedControl!
    
    weak var databaseController: DatabaseProtocol?
    weak var taskDelegate: TaskDelegate?
    
    //this holds the task that maybe edited, which is the task showing on this screen
    var editTask: Task?
    
    //this holds the task that had been edited, which is the task showing on this screen
    var newTask: Task?
    
    //flag to see if the task is edited
    var isEdit: Bool = false;
    
    //current date
    let TODAY = Date();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //forbid the user from choosing any previous date
        newDueDate.minimumDate = TODAY;
        newTask = nil

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        isEdit = false;
        
        //not nil means this task had been edited
        if editTask != nil {
            newTaskTitle.text = editTask!.taskTitle
            newTaskDescription.text = editTask!.taskDescription
            newDueDate.date = editTask!.dueDate! as Date
            if editTask!.isCompleted {
                newStatus.selectedSegmentIndex = 1
            }
            else {
                newStatus.selectedSegmentIndex = 0
                
            }
            
            //check if the task is overdue, if true remind the user
            let components = Calendar.current.dateComponents([.day], from: self.editTask!.dueDate! as Date, to: self.TODAY)
            
            if components.day! > 0 && !self.editTask!.isCompleted {
                self.displayMessage(title: "Important", message: "This task is overdue! You can only choose today or onward as your new due date!")
            }
            isEdit = true
        }
    }
    
    //add or edit the task when user finished
    @IBAction func onFinish(_ sender: Any) {
        let rtn: Bool?
        if(newTaskTitle.text! == "") {
            displayMessage(title: "Fail", message: "Please enter a title!")
            return
        }
        if newStatus.titleForSegment(at: newStatus.selectedSegmentIndex) == "No" {
            rtn = false
        }
        else {
            rtn = true
        }
        
        //if the task is edited delete the old one and add the edited task back to the container
        if isEdit {
            databaseController?.deleteTask(task: self.editTask!)
            editTask = nil
        }
        newTask = databaseController!.addTask(title: newTaskTitle.text!, des: newTaskDescription.text!, due: newDueDate.date < TODAY ? TODAY : newDueDate.date, completed: rtn!)
        if isEdit {
            taskDelegate!.taskIsEdited(task: newTask!)
        }
        navigationController?.popViewController(animated: true)
    }
    
    //method for invoking the message box
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }

}
