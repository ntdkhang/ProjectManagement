//
//  ContentView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("selectedView") var selectedView: String?
	@EnvironmentObject var dataController: DataController
    var body: some View {
        TabView(selection: $selectedView) {
            HomeView()
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
			ProjectsView(dataController: dataController, showFinishedProjects: false)
                .tag(ProjectsView.ongoingTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Ongoing")
                }
            
            ProjectsView(dataController: dataController, showFinishedProjects: true)
                .tag(ProjectsView.finishedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Finished")
                }
            
            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
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
