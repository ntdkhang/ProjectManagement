//
//  ExtensionsTests.swift
//  ProjectManagementTests
//
//  Created by Nguyen Tran Duy Khang on 3/28/22.
//

import SwiftUI
import XCTest
@testable import ProjectManagement

class ExtensionsTests: BaseTestCase {
	func testSequenceKeyPathSortingSelf() {
		let items = [3, 1, 4, 5, 2, 6]
		let sortedItems = items.sorted(by: \.self)
		
		XCTAssertEqual(sortedItems, [1, 2, 3, 4, 5, 6], "Items must be sorted in ascending order")
	}
	
	func testSequenceKeyPathWithCustomComparator() {
		/// A struct just for testing the sort functions
		struct Person: Equatable {
			var name: String
			var age: Int
		}
		
		let p1 = Person(name: "person1", age: 14)
		let p2 = Person(name: "person1", age: 15)
		let p3 = Person(name: "person2", age: 25)
		let p4 = Person(name: "person3", age: 35)
		let p5 = Person(name: "person3", age: 38)
		
		let persons = [p2, p4, p1, p5, p3]
		let sortedPersons = persons.sorted(by: \.self) {
			if ($0.name < $1.name) {
				return true
			} else if ($0.name == $1.name) {
				if $0.age < $1.age {
					return true
				}
			}
			return false
		}
		let correctlyOrderedPersons = [p1, p2, p3, p4, p5]
		XCTAssertEqual(sortedPersons, correctlyOrderedPersons)
	}
	
	func testBundleDecodingAwards() {
		let awards = Bundle.main.decode([Award].self, from: "Awards.json")
		XCTAssertFalse(awards.isEmpty, "Awards.json should never be empty")
	}
	
	func testDecodingString() {
		let bundle = Bundle(for: ExtensionsTests.self)
		let data =  bundle.decode(String.self, from: "DecodableString.json")
		XCTAssertEqual(data, "This is just a random String",
					   "Decoded string must match string in DecodableString.json")
	}
	
	func testDecodingDictionary() {
		let bundle = Bundle(for: ExtensionsTests.self)
		let data = bundle.decode([String : Int].self, from: "DecodableDictionary.json")
		XCTAssertEqual(data.count, 3, "There should be 3 pairs decoded from DecodableDictionary.json")
		XCTAssertEqual(data["one"], 1, "The dictionary should contains string to int mapping")
	}
	
	func testBindingOnChange() {
		var onChangeFunctionRun = false
		
		func exampleFunctionToCall() {
			onChangeFunctionRun = true
		}
		 
		var storedValue = ""
		
		let binding = Binding (
			get: { storedValue },
			set: { storedValue = $0 }
		)
		let changedBinding = binding.onChange(exampleFunctionToCall)
		changedBinding.wrappedValue = "new value"
		XCTAssertTrue(onChangeFunctionRun, "exampleFunctionToCall() should run when we change the binding")
	}
	
}
