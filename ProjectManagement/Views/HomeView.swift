//
//  HomeView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//
import CoreData
import SwiftUI

struct HomeView: View {
    static var tag: String? = "Home"
    
    @EnvironmentObject var dataController: DataController
    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
                  predicate: NSPredicate(format: "finished = false"))
    var projects: FetchedResults<Project>
    let tasks: FetchRequest<Task>
    
    let projectRows: [GridItem] = [
        GridItem(.fixed(100))
    ]
    
    init() {
		let request: NSFetchRequest<Task> = NSFetchRequest(entityName: "Task")
		
		let taskCompletePredicate = NSPredicate(format: "completed = false")
		let projectFinishPredicate = NSPredicate(format: "project.finished = false")
		let compoundPredicate = NSCompoundPredicate(type: .and,
													subpredicates: [taskCompletePredicate,
																	projectFinishPredicate])
		request.predicate = compoundPredicate
		request.sortDescriptors = [
			NSSortDescriptor(keyPath: \Task.priority, ascending: false)
		]
		request.fetchLimit = 10
		tasks = FetchRequest(fetchRequest: request)
    }
	
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
							ForEach(projects, content: ProjectSummaryView.init)
						}
                        .padding([.horizontal, .top], 8)
//                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack (alignment: .leading) {
						TaskListView(title: "Up next", tasks: tasks.wrappedValue.prefix(3))
						TaskListView(title: "More to come", tasks: tasks.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
					                                Button {
					                                    dataController.deleteAll()
					                                    try? dataController.createSampleData()
					                                } label: {
					                                    Text("Add data")
					                                }
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }

    }
    
}



struct HomeView_Previews: PreviewProvider {
    static let dataController = DataController.preview
    static var previews: some View {
        HomeView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
