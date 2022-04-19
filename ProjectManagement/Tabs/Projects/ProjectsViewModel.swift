//
//  ProjectsViewModel.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 4/18/22.
//

import Foundation
import CoreData
import SwiftUI

extension ProjectsView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		let showFinishedProjects: Bool
		var sortOrder = Task.SortOrder.optimized
		
		let dataController: DataController
		
		private let projectsController: NSFetchedResultsController<Project>
		
		@Published var projects = [Project]()
		
		init(dataController: DataController, showFinishedProjects: Bool) {
			self.dataController = dataController
			self.showFinishedProjects = showFinishedProjects
			
			let request: NSFetchRequest<Project> = Project.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: true)]
			request.predicate = NSPredicate(format: "finished = %d", showFinishedProjects)
			
			projectsController = NSFetchedResultsController(
				fetchRequest: request,
				managedObjectContext: dataController.container.viewContext,
				sectionNameKeyPath: nil, cacheName: nil
			)
		
			super.init()
			projectsController.delegate = self
			
			do {
				try projectsController.performFetch()
				projects = projectsController.fetchedObjects ?? []
			} catch {
				print("Failed to fetch Projects")
			}
		}
		
		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newProjects = controller.fetchedObjects as? [Project] {
				self.projects = newProjects
			}
		}

		func deleteTasks(_ offsets: IndexSet, from project: Project) {
			let allTasks = project.projectTasks(using: sortOrder)
			for offset in offsets {
				let task = allTasks[offset]
				dataController.delete(task)
			}
			dataController.save()
		}
		
		func addTask(to project: Project) {
			let task = Task(context: dataController.container.viewContext)
			task.project = project
			task.creationDate = Date()
			dataController.save()
		}
		
		func addProject() {
			let project = Project(context: dataController.container.viewContext)
			project.finished = false
			project.creationDate = Date()
			dataController.save()
		}

	}
}
