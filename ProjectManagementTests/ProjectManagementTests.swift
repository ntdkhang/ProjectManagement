//
//  ProjectManagementTests.swift
//  ProjectManagementTests
//
//  Created by Nguyen Tran Duy Khang on 3/19/22.
//

import XCTest
import CoreData
@testable import ProjectManagement


/// Base test case for any other test case that will build
/// upon the use of core data
class BaseTestCase: XCTestCase {
	var dataController: DataController!
	var managedObjectContext: NSManagedObjectContext!
	
	
	/// Set up the data controller and the context
	override func setUpWithError() throws {
		dataController = DataController(inMemory: true)
		managedObjectContext = dataController.container.viewContext
	}

}
