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
    
    weak var addTaskDelegate: TaskDelegate?
    
    let today = Date();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newDueDate.minimumDate = today;

        // Do any additional setup after loading the view.
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
        let task = Task(title: newTaskTitle.text!, des: newTaskDescription.text!, due: newDueDate.date, stat: rtn!)
        let _ = addTaskDelegate!.addTask(newTask: task)
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

}
