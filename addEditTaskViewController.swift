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
    var editTask: Task?
    var newTask: Task?
    var isEdit: Bool = false;
    
    let today = Date();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newDueDate.minimumDate = today;
        newTask = nil

        // Do any additional setup after loading the view.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        databaseController = appDelegate.databaseController
        isEdit = false;
        
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
            
            let components = Calendar.current.dateComponents([.day], from: self.editTask!.dueDate! as Date, to: self.today)
            
            if components.day! < 0 && !self.editTask!.isCompleted {
                self.displayMessage(title: "Important", message: "This task is overdue! You can only choose today or onward as your new due date!")
            }
            isEdit = true
        }
    }
    
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
        if isEdit {
            databaseController?.deleteTask(task: self.editTask!)
            editTask = nil
        }
        newTask = databaseController!.addTask(title: newTaskTitle.text!, des: newTaskDescription.text!, due: newDueDate.date, completed: rtn!)
        if isEdit {
            taskDelegate!.taskIsEdited(task: newTask!)
        }
        navigationController?.popViewController(animated: true)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func displayMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message,
                                                preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTaskSegue" {
            print("test")
        }
    }
}
