//
//  ProjectsView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//

import SwiftUI

struct ProjectsView: View {
    static var ongoingTag: String? = "Ongoing"
    static var finishedTag: String? = "Finished"
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    let showFinishedProjects: Bool
    @State private var showingSortOrder: Bool = false
    @State private var sortOrder = Task.SortOrder.optimized
    
    let projects: FetchRequest<Project>
    
    init(showFinishedProjects: Bool) {
        self.showFinishedProjects = showFinishedProjects
        
        projects = FetchRequest<Project>(entity: Project.entity(),
                                         sortDescriptors: [
            NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)],
                                         predicate: NSPredicate(format: "finished = %d", showFinishedProjects))
    }
	
	var projectList: some View {
		List {
			ForEach(projects.wrappedValue) { project in
				Section(content: {
					ForEach(project.projectTasks(using: sortOrder)) { task in
						TaskRowView(project: project, task: task)
					}
					.onDelete { offsets in
						deleteTasks(offsets, from: project)
					}
					
					if showFinishedProjects == false {
						Button {
							addTask(to: project)
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
	}
    
	var addProjectToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			if showFinishedProjects == false {
				Button(action: addProject) {
					Label("Add Project", systemImage: "plus")
				}
			}
		}
	}
	
	var showSortOrderToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Button {
				showingSortOrder.toggle()
			} label: {
				Label("Show sort order", systemImage: "arrow.up.arrow.down")
			}
		}
	}
	
	// MARK: - Body
    var body: some View {
        NavigationView {
            Group {
                if projects.wrappedValue.isEmpty {
                    Text("There's nothing here.")
                        .foregroundColor(.secondary)
                } else {
                    projectList
                }
            }
            .navigationTitle(showFinishedProjects ? "Finished Projects" : "Ongoing Projects")
            .toolbar {
				addProjectToolbarItem
				showSortOrderToolbarItem
            }
            .confirmationDialog(Text("Sort tasks by"),
                                isPresented: $showingSortOrder) {
                Button("Optimized") { sortOrder = .optimized }
                Button("Creation Date") { sortOrder = .creationDate }
                Button("Title") { sortOrder = .title }
            }
            
            SelectSomethingView()
        }
    }
	
	func deleteTasks(_ offsets: IndexSet, from project: Project) {
		let allTasks = project.projectTasks(using: sortOrder)
		for offset in offsets {
			let task = allTasks[offset]
			dataController.delete(task)
		}
		dataController.save()
	}
	
	func addTask(to project: Project) {
		withAnimation {
			let task = Task(context: managedObjectContext)
			task.project = project
			task.creationDate = Date()
			dataController.save()
		}
	}
    
	func addProject() {
		withAnimation {
			let project = Project(context: managedObjectContext)
			project.finished = false
			project.creationDate = Date()
			dataController.save()
		}
	}
    
}

struct ProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    
    static var previews: some View {
        ProjectsView(showFinishedProjects: false)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
