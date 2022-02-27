//
//  TaskListView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/24/22.
//

import SwiftUI

struct TaskListView: View {
	let title: LocalizedStringKey
	let tasks: FetchedResults<Task>.SubSequence
	
    var body: some View {
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

//struct TaskListView_Previews: PreviewProvider {
//    static var previews: some View {
//        TaskListView()
//    }
//}
