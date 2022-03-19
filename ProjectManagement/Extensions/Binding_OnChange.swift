//
//  Binding_OnChange.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/11/22.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
