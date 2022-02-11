//
//  Task_CoreDataHelpers.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/11/22.
//

import Foundation

extension Task {
    var taskTitle: String {
        title ?? ""
    }
    
    var taskDetail: String {
        detail ?? ""
    }
    
    var taskCreationDate: Date {
        creationDate ?? Date()
    }
    
    static var example: Task {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let task = Task(context: viewContext)
        task.title = "Example Task"
        task.detail = "This is an example task"
        task.creationDate = Date()
        task.completed = false
        task.priority = 3
        
        return task
    }
    
}