//
//  AwardTests.swift
//  ProjectManagementTests
//
//  Created by Nguyen Tran Duy Khang on 3/23/22.
//

import CoreData
import XCTest
@testable import ProjectManagement

class AwardTests: BaseTestCase {
	let awards = Award.allAwards
	
	func testIDMatchesName() {
		for award in awards {
			XCTAssertEqual(award.id, award.name, "ID should matches name")
		}
	}
	
	func testNoAwardForNewUser() {
		for award in awards {
			XCTAssertFalse(dataController.hasEarned(award: award), "New user should not earn any award")
		}
	}
	
	func testAddingTasks() {
		let milestones = [1, 10, 20, 50, 100, 250, 500, 1000]
		
		for (index, value) in milestones.enumerated() {
			var tasks = [Task]()
			for _ in 0..<value {
				// create new task
				let task = Task(context: managedObjectContext)
				tasks.append(task)
			}
		// count awards earned
			let count = awards.filter { award in
				award.criterion == "tasks" && dataController.hasEarned(award: award)
			}.count
			XCTAssertEqual(index + 1, count, "Adding \(value) tasks should unlock \(index + 1) award")
			for task in tasks {
				dataController.delete(task)
			}
		}
	}

	func testCompletingTasks() {
		let milestones = [1, 10, 20, 50, 100, 250, 500, 1000]
		
		for (index, value) in milestones.enumerated() {
			var tasks = [Task]()
			for _ in 0..<value {
				let task = Task(context: managedObjectContext)
				tasks.append(task)
				task.completed = true
			}
			let count = awards.filter { award in
				award.criterion == "complete" && dataController.hasEarned(award: award)
			}.count
			XCTAssertEqual(index + 1, count, "completing  \(value) tasks should unlock \(index + 1) award")
			for task in tasks {
				dataController.delete(task)
			}
		}
	}
}
