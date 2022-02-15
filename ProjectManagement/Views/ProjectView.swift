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
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let showFinishedProjects: Bool
    @State var showingSortOrder: Bool = false
    @State var sortOrder = Task.SortOrder.optimized
    
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
                        ForEach(tasks(for: project)) { task in
                            ItemRowView(task: task)
                        }
                        .onDelete { offsets in
                            let allTasks = project.projectTasks
                            
                            for offset in offsets {
                                let task = allTasks[offset]
                                dataController.delete(task)
                            }
                            
                            dataController.save()
                        }
                        
                        if showFinishedProjects == false {
                            Button {
                                withAnimation {
                                    let task = Task(context: managedObjectContext)
                                    task.project = project
                                    task.creationDate = Date()
                                    dataController.save()
                                }
                            } label: {
                                Label("Add a new task", systemImage: "plus")
                            }
                        }
                        
                    }, header: {
                        ProjectHeaderView(project: project)
                            .tint(Color(project.projectColor))
                    })
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("\(showFinishedProjects ? "Finished Projects" : "Ongoing Projects")")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if showFinishedProjects == false {
                        Button {
                            withAnimation {
                                let project = Project(context: managedObjectContext)
                                project.finished = false
                                project.creationDate = Date()
                                dataController.save()
                            }
                        } label: {
                            Label("Add Project", systemImage: "plus")
                        }
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showingSortOrder.toggle()
                    } label: {
                        Label("Show sort order", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
            .confirmationDialog(Text("Sort tasks by"),
                                isPresented: $showingSortOrder) {
                Button("Optimized") { sortOrder = .optimized }
                Button("Creation Date") { sortOrder = .creationDate }
                Button("Title") { sortOrder = .title }
            }
            
        }
    }
    
    func tasks(for project: Project) -> [Task] {
        switch sortOrder {
        case .title:
            return project.projectTasks.sorted { $0.taskTitle < $1.taskTitle }
        case .creationDate:
            return project.projectTasks.sorted { $0.taskCreationDate < $1.taskCreationDate }
        case .optimized:
            return project.projectTasksDefaultSorted
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
