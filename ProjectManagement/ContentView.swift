//
//  ContentView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ProjectView(showFinishedProjects: false)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Ongoing")
                }
            
            ProjectView(showFinishedProjects: true)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Finished")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
