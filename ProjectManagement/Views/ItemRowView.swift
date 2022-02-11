//
//  ItemRowView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/11/22.
//

import SwiftUI

struct ItemRowView: View {
    @ObservedObject var task: Task
    var body: some View {
        NavigationLink(destination: EditTaskView(task: task)) {
            Text(task.taskTitle)
        }
    }
}

//struct ItemRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemRowView()
//    }
//}
