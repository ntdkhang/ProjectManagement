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
    
	@StateObject var viewModel: ViewModel
    
    let projectRows: [GridItem] = [
        GridItem(.fixed(100))
    ]
    
	init(dataController: DataController) {
		let viewModel = ViewModel(dataController: dataController)
		_viewModel = StateObject(wrappedValue: viewModel)
	}
	
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHGrid(rows: projectRows) {
							ForEach(viewModel.projects, content: ProjectSummaryView.init)
						}
                        .padding([.horizontal, .top], 8)
//                        .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack (alignment: .leading) {
						TaskListView(title: "Up next", tasks: viewModel.upNext)
						TaskListView(title: "More to come", tasks: viewModel.moreToCome)
                    }
                    .padding(.horizontal)
				}
            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
			
			// MARK: - Tool bar button for adding debug data
//			.toolbar {
//				Button("Add Data", action: viewModel.addSampleData)
//			}
        }

    }
    
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
		HomeView(dataController: DataController.preview)
    }
}
