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
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")
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
                            ForEach(projects) { project in
                                VStack(alignment: .leading) {
                                    Text("\(project.projectTasks.count) tasks")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                    Text(project.projectTitle)
                                        .font(.title2)
                                    ProgressView(value: project.completionAmount)
                                        .tint(Color(project.projectColor))
                                }
                                .padding()
                                .background(Color.secondarySystemGroupedBackground)
                                .cornerRadius(10)
                                .shadow(color: Color.black.opacity(0.1), radius: 5)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel("\(project.projectTitle), \(project.projectTasks.count) tasks, \(project.completionAmount * 100, specifier: "%g")% complete")
                            }
                        }
                        .padding([.horizontal, .top], 8)
//                        .fixedSize(horizontal: false, vertical: true)
                    }
                        
                                Button {
                                    dataController.deleteAll()
                                    try? dataController.createSampleData()
                                } label: {
                                    Text("Add data")
                                }
                    VStack (alignment: .leading) {
                        list("Up next", for: tasks.wrappedValue.prefix(3))
                        list("More to come", for: tasks.wrappedValue.dropFirst(3))
                    }
                    .padding(.horizontal)
                }
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
    
    @ViewBuilder
    func list(_ title: LocalizedStringKey, for tasks: FetchedResults<Task>.SubSequence) -> some View {
        if tasks.isEmpty {
            EmptyView()
        } else {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.top)
            
            ForEach(tasks) { task in
                NavigationLink(destination: EditTaskView(task: task)) {
                    HStack(spacing: 20) {
                        Circle()
                            .stroke(Color(task.project?.projectColor ?? "Light Blue"), lineWidth: 3)
                            .frame(width: 45, height: 45)
                        VStack(alignment: .leading) {
                            Text(task.taskTitle)
                                .font(.title2)
                                .foregroundColor(.primary)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if !task.taskDetail.isEmpty {
                                Text(task.taskDetail)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding()
                    .background(Color.secondarySystemGroupedBackground)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.2), radius: 10)
                }
            }
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
