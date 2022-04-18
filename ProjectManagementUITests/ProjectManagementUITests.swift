//
//  ProjectManagementUITests.swift
//  ProjectManagementUITests
//
//  Created by Nguyen Tran Duy Khang on 4/13/22.
//

import XCTest

class ProjectManagementUITests: XCTestCase {
	var app: XCUIApplication!
	
	override func setUpWithError() throws {
		continueAfterFailure = false
        app = XCUIApplication()
		app.launchArguments = ["enable-testing"]
        app.launch()
	}

    func testAppHasFourTabs() throws {
		XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tab bar items")
    }
	
	func testOpenTabAddsProject() {
		app.buttons["Ongoing"].tap()
		XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially")
		
		for tapCount in 1...5 {
			app.buttons["Add Project"].tap() // The string must match the label name in the button
			XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) list row(s)")
		}
	}
	
	func testAddingTaskInsertsRow() {
		app.buttons["Ongoing"].tap()
		XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially")
		
		app.buttons["Add Project"].tap() // The string must match the label name in the button
		XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project")
		
		app.buttons["Add a new task"].tap()
		XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list row after adding a task")
	}
	
	func testEditingProjectUpdatesCorrectly() {
		app.buttons["Ongoing"].tap()
		XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially")
		
		app.buttons["Add Project"].tap() // The string must match the label name in the button
		XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a project")
		
		// edit project
		app.buttons["New project"].tap()
		app.textFields["Project name"].tap()
		
		// enter new name
		app.keys["space"].tap()
		app.keys["more"].tap()
		app.keys["2"].tap()
		app.buttons["Return"].tap()
		
		app.buttons["Ongoing Projects"].tap()
		XCTAssertTrue(app.buttons["New project 2"].exists, "Project name should change after we edit it")
	}
	
	func testEditingTaskUpdatesCorrectly() {
		// Go to ongoing tab then add 1 project then add 1 task
		testAddingTaskInsertsRow()
		
		// edit task
		app.buttons["New task, not completed"].tap() // the not completed part is added to the accessibility label in TaskRowView
		app.textFields["Task name"].tap()
		// for some reason, if I only tap once, it wouldn't go to the text field
		app.textFields["Task name"].tap()
		
		app.keys["space"].tap()
		app.keys["more"].tap()
		app.keys["1"].tap()
		app.buttons["Return"].tap()
		
		app.buttons["Ongoing Projects"].tap()
		XCTAssertTrue(app.buttons["New task 1, not completed"].exists, "Task name should change after we edit it")
	}
	
	func testAllAwardsShowLockedAlert() {
		app.buttons["Awards"].tap()
		
		for award in app.scrollViews.buttons.allElementsBoundByIndex {
			award.tap()
			XCTAssertTrue(app.alerts["Locked"].exists, "There should be a locked alert")
			app.buttons["OK"].tap()
		}
	}
}
