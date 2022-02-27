//
//  ProjectSummaryView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/24/22.
//

import SwiftUI

struct ProjectSummaryView: View {
	@ObservedObject var project: Project
    var body: some View {
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
		.accessibilityLabel(project.label)
		
	}
}

struct ProjectSummaryView_Previews: PreviewProvider {
    static var previews: some View {
		ProjectSummaryView(project: Project.example)
    }
}
