//
//  TaskRowView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/11/22.
//

import SwiftUI

struct TaskRowView: View {
    @ObservedObject var project: Project
    @ObservedObject var task: Task
    
    var icon: some View {
        if task.completed {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(Color(project.projectColor))
        } else if task.priority == 3 {
            return Image(systemName: "exclamationmark.triangle")
                .foregroundColor(Color(project.projectColor))
        } else {
            return Image(systemName: "checkmark.circle")
                .foregroundColor(.clear)
        }
    }
	
	var label: Text {
		if task.completed {
			return Text("\(task.taskTitle), completed")
		} else if !task.completed && task.priority == 3 {
			return Text("\(task.taskTitle), high priority, not completed")
		} else {
			return Text("\(task.taskTitle), not completed")
		}
	}
    
    var body: some View {
        NavigationLink(destination: EditTaskView(task: task)) {
            Label {
                Text(task.taskTitle)
            } icon: {
                icon
            }
        }
		.accessibilityLabel(label) 
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(project: Project.example, task: Task.example)
    }
}
