//
//  Project_CoreDataHelpers.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/11/22.
//

import Foundation

extension Project {
    static let colors = ["Pink", "Purple", "Red", "Orange", "Gold", "Green", "Teal",
                         "Light Blue", "Dark Blue", "Midnight", "Dark Gray", "Gray"]
    var projectTitle: String {
        title ?? "New project"
    }
    
    var projectDetail: String {
        detail ?? ""
    }
    
    var projectColor: String {
        color ?? "Light Blue"
    }
    
    var projectTasks: [Task] {
        return tasks?.allObjects as? [Task] ?? []
    }
    
    var projectTasksDefaultSorted: [Task] {
        return projectTasks.sorted {
            sortTasksDefault(first: $0, second: $1)
        }
    }
    
    var completionAmount: Double {
        let totalTasks = tasks?.allObjects as? [Task] ?? []
        guard (totalTasks.isEmpty == false) else { return 0 }
        
        let completedTasks = totalTasks.filter { $0.completed }
        return Double(completedTasks.count) / Double(totalTasks.count)
    }
    
    static var example: Project {
        let controller = DataController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example project"
        project.finished = true
        project.creationDate = Date()
        
        return project
    }
    
    
    private func sortTasksDefault(first: Task, second: Task) -> Bool {
        // uncompleted tasks go first, completed stay at the bottom
        if (first.completed == true) {
            if second.completed == false {
                return false
            }
        } else if first.completed == false {
            if second.completed == true {
                return true
            }
        }
        
        // remaining case: both uncompleted or both completed
        // now sort by priority
        if (first.priority > second.priority) {
            return true
        } else if first.priority < second.priority {
            return false
        }
        
        // remaining case: same priority
        // now sort by creation date
        return first.taskCreationDate < second.taskCreationDate
        
    }
    
}
