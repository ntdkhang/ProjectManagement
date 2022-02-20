//
//  EditProjectView.swift
//  ProjectManagement
//
//  Created by Nguyen Tran Duy Khang on 2/12/22.
//

import SwiftUI

struct EditProjectView: View {
    var project: Project
    @EnvironmentObject var dataController: DataController
    @Environment(\.dismiss) var dismiss
    
    @State private var showingDeleteConfirmation: Bool = false
    @State private var title: String
    @State private var detail: String
    @State private var color: String
    
    let colorColumns = [
        GridItem(.adaptive(minimum: 44))
    ]
    
    init(project: Project) {
        self.project = project
        _title = State(wrappedValue: project.projectTitle)
        _detail = State(wrappedValue: project.projectDetail)
        _color = State(wrappedValue: project.projectColor)
    }
    
    var body: some View {
        Form {
            Section("Basic settings") {
                TextField("Project name", text: $title.onChange(update))
                TextField("Description", text: $detail.onChange(update))
            }
            
            Section("Custom project color") {
                LazyVGrid(columns: colorColumns) {
                    ForEach(Project.colors, id: \.self) { colorPalette in
                        ZStack {
                            Color(colorPalette)
                                .aspectRatio(1, contentMode: .fit)
                                .cornerRadius(6)
                            if colorPalette == self.color {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.white)
                                    .font(.largeTitle)
                            } 
                        }
                        .onTapGesture {
                            self.color = colorPalette
                            update()
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityAddTraits(
                            colorPalette == self.color
                            ? [.isButton, .isSelected]
                            : .isButton
                        )
                        .accessibilityLabel(LocalizedStringKey(colorPalette))
                    }
                }
                .padding(.vertical)
            }
            
            Section {
                Button(project.finished ? "Reopen this project" : "Finish this project") {
                    project.finished.toggle()
                    update()
                }
                
                Button("Delete the project") {
                    showingDeleteConfirmation = true
                }
                .tint(.red)
            } footer: {
                Text("Finishing the project put it in the Finished tab; deleting it removes the project entirely.")
            }
            
        }
        .navigationTitle("Edit Project")
        .onDisappear(perform: dataController.save)
        .alert(isPresented: $showingDeleteConfirmation) {
            Alert(title: Text("Delete project?"),
                  message: Text("Are you sure you want to delete this project? All data will be removed and cannot be undone"),
                  primaryButton: .destructive(Text("Delete"), action: delete),
                  secondaryButton: .cancel())
        }
    }
    
    func update() {
        project.objectWillChange.send()
        
        project.title = title
        project.detail = detail
        project.color = color
        
    }
    
    func delete() {
        dataController.delete(project)
        dismiss.callAsFunction()
    }
}

struct EditProjectView_Previews: PreviewProvider {
    static var dataController = DataController.preview
    static var previews: some View {
        EditProjectView(project: Project.example)
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
