//
//  AwardsView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/16/22.
//

import SwiftUI

struct AwardsView: View {
    static let tag: String? = "Awards"
    
    @EnvironmentObject var dataController: DataController
    @State private var selectedAward = Award.example
    @State private var showingAwardDetails = false
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 100, maximum: 100))]
    }
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(Award.allAwards) { award in
                        Button {
                            selectedAward = award
                            showingAwardDetails.toggle()
                        } label: {
                            Image(systemName: award.image)
                                .resizable()
                                .scaledToFit()
                                .padding()
                                .frame(width: 100, height: 100)
                                .foregroundColor(dataController.hasEarned(award: award) ?
                                                 Color(award.color) : Color.secondary.opacity(0.5))
                        }
                    }
                }
            }
            .navigationTitle("Awards")
            .alert(alertTitle, isPresented: $showingAwardDetails, actions: {},
                   message: { Text(selectedAward.description) })
        }
    }
    
    var alertTitle: String {
        dataController.hasEarned(award: selectedAward) ? "Unlocked: \(selectedAward.name)" : "Locked"
    }
}

//struct AwardsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AwardsView()
//    }
//}