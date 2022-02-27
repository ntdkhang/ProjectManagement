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
                        awardButton(for: award)
                    }
                }
            }
            .navigationTitle("Awards")
            .alert(alertTitle,
				   isPresented: $showingAwardDetails,
				   actions: {},
                   message: { Text(selectedAward.description) })
        }
    }
	
	func awardButton(for award: Award) -> some View {
		Button {
			selectedAward = award
			showingAwardDetails.toggle()
		} label: {
			Image(systemName: award.image)
				.resizable()
				.scaledToFit()
				.padding()
				.frame(width: 100, height: 100)
				.foregroundColor(color(for: award))
		}
		.accessibilityLabel(label(for: award))
		.accessibilityHint(Text(award.description))
	}

	func color(for award: Award) -> Color {
		dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5)
	}

	func label(for award: Award) -> Text {
		Text(dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked")
	}
    
    var alertTitle: String {
        dataController.hasEarned(award: selectedAward) ? "Unlocked: \(selectedAward.name)" : "Locked"
    }
}


