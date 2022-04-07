//
//  DataController.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//

import CoreData
import SwiftUI


/// A singleton responsible for managing our Core Data, perform basic functions like saving,
/// deleting, counting fetch requests, checking awards, and handling sample data.
class DataController: ObservableObject {
	
	/// A CloudKit container used to store our data.
	let container: NSPersistentCloudKitContainer
    
	
	/// Initializes a DataController for your app to store your data either in temporary memory or in permanent storage.
	///
	/// Defaults to permanent storage.
	/// - Parameter inMemory: Whether to store the data in temporary memory or permanent storage. Defaults to permanent.
    init(inMemory: Bool = false) {
		container = NSPersistentCloudKitContainer(name: "Main", managedObjectModel: Self.model)
        
		// use a temporary database for testing purposes
		// data in /dev/null will be automatically deleted after our app finished running
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                fatalError("Fatal error loading store: \(error.localizedDescription)")
            }
        }
    }
	
	
	static let model: NSManagedObjectModel = {
		guard let url = Bundle.main.url(forResource: "Main", withExtension: "momd") else {
			fatalError("Failed to load model")
		}
		
		guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
			fatalError("Failed to load model")
		}
		
		return managedObjectModel
	}()
    
	
	/// Sample data for previewing.
    static var preview: DataController = {
        let dataController = DataController(inMemory: true)
        let viewContext = dataController.container.viewContext
        
        do {
            try dataController.createSampleData()
        } catch {
            fatalError("Fatal error in creating preview data \(error.localizedDescription)")
        }
        
        return dataController
    }()
        
	
	
	
	/// Creates sample projects and tasks for manual testing.
	/// - Throws: An NSError from calling save() on NSManagedObjectContext.
	func createSampleData(with targetNumber: Int = 5) throws {
        let viewContext = container.viewContext
        
        for i in 1...targetNumber {
            let project = Project(context: viewContext)
            project.title = "Project \(i)"
            project.tasks = []
            project.creationDate = Date()
            project.finished = Bool.random()
            
            for j in 1...(targetNumber*2) {
                let task = Task(context: viewContext)
                task.title = "Task \(i).\(j)"
                task.completed = Bool.random()
                task.creationDate = Date()
                task.project = project
                task.priority = Int16.random(in: 1...3)
            }
        }
        
        try viewContext.save()
    }
    
	
	/// Saves our Core Data view context only if there are changes. Errors
	/// are ignored.
	///
	/// We don't have to worry about errors while saving because all
	/// our attributes are optional.
    func save() {
        if container.viewContext.hasChanges {
            try? container.viewContext.save()
        }
    }
    
	
	/// Delete an object from Core Data.
	/// - Parameter object: The object you want to delete, whether a Project or a Task object.
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
    }
    
	
	/// Delete all tasks and projects from Core Data.
    func deleteAll() {
        let fetchRequest1: NSFetchRequest<NSFetchRequestResult> = Task.fetchRequest()
        let batchDeleteRequest1 = NSBatchDeleteRequest(fetchRequest: fetchRequest1)
        _ = try? container.viewContext.execute(batchDeleteRequest1)
//        print(deletion1.debugDescription)
        
        let fetchRequest2: NSFetchRequest<NSFetchRequestResult> = Project.fetchRequest()
        let batchDeleteRequest2 = NSBatchDeleteRequest(fetchRequest: fetchRequest2)
        _ = try? container.viewContext.execute(batchDeleteRequest2)
//        print(deletion2.debugDescription)
    }
    
	
	/// Count the number of objects returned by a fetch request.
	/// - Returns: The number of object for this fetch request. Returns 0.
	/// if the count() method from the context fails.
	/// - Parameter fetchRequest: The fetch request you want to count.
    func count<T>(for fetchRequest: NSFetchRequest<T>) -> Int {
        (try? container.viewContext.count(for: fetchRequest)) ?? 0
    }
    
	
	/// Check whether the user has earned an award.
	/// - Parameter award: The award to check
	/// - Returns: A boolean. True if the user has earned that award, false otherwise.
    func hasEarned(award: Award) -> Bool {
        switch award.criterion {
        case "tasks":
			// return true if the user has added a specific number of tasks
            let fetchRequest: NSFetchRequest<Task> = NSFetchRequest(entityName: "Task")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        case "complete":
			// return true if the user has completed a specific number of tasks
			let fetchRequest: NSFetchRequest<Task> = NSFetchRequest(entityName: "Task")
            fetchRequest.predicate = NSPredicate(format: "completed = true")
            let awardCount = count(for: fetchRequest)
            return awardCount >= award.value
        default:
			// unknown criterion is not allowed. check for typo
//            fatalError("Unknown criterion: \(award.criterion)")
            return false
        }
        
    }
			
}
