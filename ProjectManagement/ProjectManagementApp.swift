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
                .onReceive(
					// automatically save the data when the app is no longer in the foreground.
					// use this instead of the Scene Phase API because I want to port this app to
					// MacOS in the future (scene phase cannot detect our app not being focused on)
					NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                           perform: save
				)
					
        }
    }
    
    func save(_ note: Notification) {
        dataController.save()
    }
}
