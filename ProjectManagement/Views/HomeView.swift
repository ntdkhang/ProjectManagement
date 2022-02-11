//
//  HomeView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/9/22.
//

import SwiftUI

struct HomeView: View {
    static var tag: String? = "Home"
    
    @EnvironmentObject var dataController: DataController
    
    var body: some View {
        NavigationView {
            VStack {
                Button("Add data") {
                    dataController.deleteAll()
                    try? dataController.createSampleData()
                }
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
