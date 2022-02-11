//
//  ProjectView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//

import SwiftUI

struct ProjectView: View {
    static var ongoingTag: String? = "Ongoing"
    static var finishedTag: String? = "Finished"
    
    let showFinishedProjects: Bool
    
    let projects: FetchRequest<Project>
    
    init(showFinishedProjects: Bool) {
        self.showFinishedProjects = showFinishedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(),
                                         sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)],
                                         predicate: NSPredicate(format: "finished = %d", showFinishedProjects))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(projects.wrappedValue) { project in
                    Section(content: {
                        ForEach(project.projectTasks) { task in
                            ItemRowView(task: task)
                        }
                    }, header: {
                        Text(project.projectTitle)
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("\(showFinishedProjects ? "Finished Projects" : "Ongoing Projects")")
        }
    }
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectView(showFinishedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
