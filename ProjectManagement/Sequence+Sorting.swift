//
//  Sequence+Sorting.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/16/22.
//

import Foundation

extension Sequence {
    func sorted<Value>(by keyPath: KeyPath<Element, Value>,
                       using areInIncreasingOrder: (Value, Value) throws -> Bool) rethrows -> [Element] {
        try self.sorted {
            try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
        }
    }
    
    func sorted<Value: Comparable>(by keyPath: KeyPath<Element, Value>) -> [Element] {
        return self.sorted(by: keyPath, using: <)
    }
    
    func sorted(by sortDescriptor: NSSortDescriptor) -> [Element] {
        return self.sorted {
            sortDescriptor.compare($0, to: $1) == .orderedAscending
        }
    }
    
    func sorted(by sortDescriptors: [NSSortDescriptor]) -> [Element] {
        self.sorted {
            for descriptor in sortDescriptors {
                switch descriptor.compare($0, to: $1) {
                case .orderedAscending:
                    return true
                case .orderedDescending:
                    return false
                case .orderedSame:
                    continue
                }
            }
            return false
        }
    }
}
