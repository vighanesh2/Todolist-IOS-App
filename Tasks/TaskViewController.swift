//
//  TaskViewController.swift
//  Tasks
//
//  Created by Ramakant on 6/11/24.
//

import UIKit

class TaskViewController: UIViewController {
    @IBOutlet var label: UILabel!
    var task: String?
    var taskIndex: Int?
    var update: (() -> Void)? // Added update property

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = task
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
    }

    @objc func deleteTask() {
        guard let index = taskIndex else { return }
        
        // Get current count of tasks
        guard let count = UserDefaults().value(forKey: "count") as? Int else { return }

        print("Deleting task at index: \(index)")

        // Remove the task from UserDefaults
        UserDefaults().removeObject(forKey: "task_\(index + 1)")

        // Shift remaining tasks up
        for i in index + 1..<count {
            if let nextTask = UserDefaults().value(forKey: "task_\(i + 1)") as? String {
                UserDefaults().setValue(nextTask, forKey: "task_\(i)")
            }
        }
        UserDefaults().removeObject(forKey: "task_\(count)")

        // Update the count
        UserDefaults().setValue(count - 1, forKey: "count")

        print("Task deleted. Updating tasks...")

        // Call the update closure
        update?()

        // Go back to the previous screen
        navigationController?.popViewController(animated: true)
    }
}
