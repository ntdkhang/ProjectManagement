//
//  AssetTest.swift
//  ProjectManagementTests
//
//  Created by Nguyen Tran Duy Khang on 3/21/22.
//

import XCTest
@testable import ProjectManagement


/// Test if all the assets are working
class AssetTest: XCTestCase {
	/// test if color names exist in the asset
	func testColorsExist() {
		for color in Project.colors {
			// use UIColor because SwiftUI color always work
			XCTAssertNotNil(UIColor(named: color),
							"Failed to load color '\(color)' from asset catalog")
			
		}
	}
	
	func testLoadAwardJSON() {
		XCTAssertFalse(Award.allAwards.isEmpty, "Failed to load award")
	}
}
