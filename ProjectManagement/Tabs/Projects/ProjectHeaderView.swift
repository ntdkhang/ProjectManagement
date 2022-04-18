//
//  ProjectHeaderView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/12/22.
//

import SwiftUI

struct ProjectHeaderView: View {
    @ObservedObject var project: Project
    
    var body: some View {
		NavigationLink(destination: EditProjectView(project: project)) {
			HStack {
				VStack(alignment: .leading) {
					Text(project.projectTitle)
					
					ProgressView(value: project.completionAmount)
				}
				
				Spacer()
				
				Image(systemName: "square.and.pencil")
					.imageScale(.large)
					.accessibilityLabel("EDIT PROJECT")
			}
        }
        .padding(.bottom, 8)
        .accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectHeaderView(project: Project.example)
    }
}
