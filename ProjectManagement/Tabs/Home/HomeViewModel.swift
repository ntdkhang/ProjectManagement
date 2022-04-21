//
//  HomeViewModel.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 4/19/22.
//

import Foundation
import CoreData

extension HomeView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		private let projectsController: NSFetchedResultsController<Project>
		private let tasksController: NSFetchedResultsController<Task>
		
		@Published var projects = [Project]()
		@Published var tasks = [Task]()
		
		var dataController: DataController
		
		var upNext: ArraySlice<Task> {
			tasks.prefix(3)
		}
		
		var moreToCome: ArraySlice<Task> {
			tasks.dropFirst(3)
		}
		
		init(dataController: DataController) {
			self.dataController = dataController
			
			// Fetch request for all ongoing projects
			let projectRequest: NSFetchRequest<Project> = Project.fetchRequest()
			projectRequest.predicate = NSPredicate(format: "finished = false")
			projectRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title,
															   ascending: true)]
			
			projectsController = NSFetchedResultsController(
				fetchRequest: projectRequest,
				managedObjectContext: dataController.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)
			
			
			// Fetch request for 10 highest-priority incomplete tasks from ongoing projects
			let taskRequest: NSFetchRequest<Task> = NSFetchRequest(entityName: "Task")
			
			let taskCompletePredicate = NSPredicate(format: "completed = false")
			let projectFinishPredicate = NSPredicate(format: "project.finished = false")
			let compoundPredicate = NSCompoundPredicate(type: .and,
														subpredicates: [taskCompletePredicate,
																		projectFinishPredicate])
			taskRequest.predicate = compoundPredicate
			taskRequest.sortDescriptors = [
				NSSortDescriptor(keyPath: \Task.priority, ascending: false)
			]
			taskRequest.fetchLimit = 10
			
			tasksController = NSFetchedResultsController(
				fetchRequest: taskRequest,
				managedObjectContext: dataController.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)
			
			
			super.init()
			projectsController.delegate = self
			tasksController.delegate = self
			
			do {
				try projectsController.performFetch()
				try tasksController.performFetch()
				projects = projectsController.fetchedObjects ?? []
				tasks = tasksController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch projects or tasks")
			}
			
		}
		
		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newTasks = controller.fetchedObjects as? [Task] {
				tasks = newTasks
			} else if let newProjects = controller.fetchedObjects as? [Project] {
				projects = newProjects
			}
		}
		
		
		func addSampleData() {
			dataController.deleteAll()
			try? dataController.createSampleData()
		}
	}
}
