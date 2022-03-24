//
//  ProjectTests.swift
//  ProjectManagementTests
//
//  Created by Nguyen Tran Duy Khang on 3/23/22.
//

import XCTest
@testable import ProjectManagement
import CoreData

class ProjectTests: BaseTestCase {
	
	/// Test if we can create projects and tasks
	func testProjectsAndTasksCreation() {
		let targetNumber = 10
		
		for _ in 0..<targetNumber {
			let project = Project(context: managedObjectContext)
			
			for _ in 0..<targetNumber {
				let task = Task(context: managedObjectContext)
				task.project = project
			}
		}
		
		XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetNumber)
		XCTAssertEqual(dataController.count(for: Task.fetchRequest()), targetNumber * targetNumber)
	}
	
	
	/// Test if deleting a project also deletes its tasks.
	///
	/// Marking it with throws will make it to where if anything inside it
	/// throws, the test will fail
	func testProjectCascadeDeletesTasks() throws {
		let targetNumber = 5
		try dataController.createSampleData(with: targetNumber)
		
		let request = NSFetchRequest<Project>(entityName: "Project")
		let projects = try managedObjectContext.fetch(request)
		dataController.delete(projects[0])
		
		XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetNumber - 1)
		XCTAssertEqual(dataController.count(for: Task.fetchRequest()), 2 * targetNumber * (targetNumber - 1))
	}

}
