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
    
	@StateObject var viewModel: ViewModel
	
    @State private var showingSortOrder: Bool = false
	
	var projectList: some View {
		List {
			ForEach(viewModel.projects) { project in
				Section(content: {
					ForEach(project.projectTasks(using: viewModel.sortOrder)) { task in
						TaskRowView(project: project, task: task)
					}
					.onDelete { offsets in
						viewModel.deleteTasks(offsets, from: project)
					}
					
					if viewModel.showFinishedProjects == false {
						Button {
							withAnimation {
								viewModel.addTask(to: project)
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
	}
    
	var addProjectToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			if viewModel.showFinishedProjects == false {
				Button {
					withAnimation { viewModel.addProject() }
				} label: {
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
                if viewModel.projects.isEmpty {
                    Text("There's nothing here.")
                        .foregroundColor(.secondary)
                } else {
                    projectList
                }
            }
            .navigationTitle(viewModel.showFinishedProjects ? "Finished Projects" : "Ongoing Projects")
            .toolbar {
				addProjectToolbarItem
				showSortOrderToolbarItem
            }
            .confirmationDialog(Text("Sort tasks by"),
                                isPresented: $showingSortOrder) {
                Button("Optimized") { viewModel.sortOrder = .optimized }
                Button("Creation Date") { viewModel.sortOrder = .creationDate }
                Button("Title") { viewModel.sortOrder = .title }
            }
            
            SelectSomethingView()
        }
    }
	
	init(dataController: DataController, showFinishedProjects: Bool) {
		let viewModel = ViewModel(dataController: dataController, showFinishedProjects: showFinishedProjects)
		_viewModel = StateObject(wrappedValue: viewModel)
	}
    
}

struct ProjectView_Previews: PreviewProvider {
    
    static var previews: some View {
		ProjectsView(dataController: DataController.preview, showFinishedProjects: false)
    }
}
