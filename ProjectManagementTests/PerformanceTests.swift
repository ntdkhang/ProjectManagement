//
//  PerformanceTests.swift
//  ProjectManagementTests
//
//  Created by Nguyen Tran Duy Khang on 4/13/22.
//

import XCTest
@testable import ProjectManagement

class PerformanceTests: BaseTestCase {
	func testAwardCalculationPerformance() throws {
		// create a huge amount of sample data
		for _ in 1...100 {
			try dataController.createSampleData()
		}
		// create lots of awards to check
		let awards = Array(repeating: Award.allAwards, count: 25).joined()
		
		XCTAssertEqual(Award.allAwards.count, 20, "The number of awards has changed! Please also update this value")
		
		measure {
			_ = awards.filter(dataController.hasEarned)
		}
	}
}
