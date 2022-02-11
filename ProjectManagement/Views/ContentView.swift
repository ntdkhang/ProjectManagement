//
//  ContentView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            ProjectView(showFinishedProjects: false)
                .tag(ProjectView.ongoingTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Ongoing")
                }
            
            ProjectView(showFinishedProjects: true)
                .tag(ProjectView.finishedTag)
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
