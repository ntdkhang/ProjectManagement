//
//  DevelopmentTests.swift
//  ProjectManagementTests
//
//  Created by Nguyen Tran Duy Khang on 3/24/22.
//

import CoreData
import XCTest
@testable import ProjectManagement

class DevelopmentTests: BaseTestCase {
	func testSampleDataCreation() throws {
		try dataController.createSampleData()
		XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 projects.")
		XCTAssertEqual(dataController.count(for: Task.fetchRequest()), 50, "There should be 50 projects.")
	}
	
	func testDeleteAllData() throws {
		try dataController.createSampleData()
		dataController.deleteAll()
		
		XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "There should be no project.")
		XCTAssertEqual(dataController.count(for: Task.fetchRequest()), 0, "There should be no task.")
	}
	
	func testExampleProjectIsFinished() {
		let project = Project.example
		
		XCTAssertTrue(project.finished, "The example project should be finished.")
	}
	
	func testExampleTaskIsHighPriority() {
		let task = Task.example
		
		XCTAssertEqual(task.priority, 3, "Example task should be high priority.")
	}

}
