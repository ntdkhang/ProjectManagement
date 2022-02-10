//
//  ProjectManagementApp.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//

import SwiftUI

@main
struct ProjectManagementApp: App {
    @StateObject var dataController: DataController
    
    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
        }
    }
}
