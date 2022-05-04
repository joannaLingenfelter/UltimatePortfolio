//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/8/22.
//

import SwiftUI

struct ProjectsView: View {
    static var openTag: String?  = "Open"
    static var closedTag: String? = "Closed"

    @State private var showingSortOrder = false
    @StateObject var viewModel: ViewModel

    init(dataController: DataController, showClosedProjects: Bool) {
        let viewModel = ViewModel(dataController: dataController,
                                  showClosedProjects: showClosedProjects)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    private var projectsList: some View {
        List {
            ForEach(viewModel.projects) { project in
                Section {
                    ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(project: project, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.deleteItems(from: project, at: offsets)
                    }

                    if viewModel.showClosedProjects == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: project)
                            }
                        } label: {
                            Label(Strings.addNewItem.key, systemImage: "plus")
                        }
                    }
                } header: {
                    ProjectHeaderView(project: project)
                }

            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    private var addProjectToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.showClosedProjects == false {
                Button {
                    withAnimation {
                        viewModel.createProject()
                    }
                } label: {
                    // Fixes an iOS 14.3 bug where voiceover reads the label
                    // "Add Project" as "Add" no matter what the accessibility
                    // label is made to say.  This code ensures that when voiceover
                    // is running the the button reads "Add Project".
                    if UIAccessibility.isVoiceOverRunning {
                        Text(Strings.addProject.key)
                    } else {
                        Label(Strings.addProject.key, systemImage: "plus")
                    }
                }
            }
        }
    }

    private var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label(Strings.sort.key, systemImage: "arrow.up.arrow.down")
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.projects.isEmpty {
                    Text(Strings.nothingHereRightNow.key)
                        .foregroundColor(.secondary)
                } else {
                    projectsList
                }
            }
            .navigationTitle(viewModel.showClosedProjects ? Strings.closedProjects.key : Strings.openProjects.key)
            .toolbar {
                addProjectToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text(Strings.sortItems.key), message: nil, buttons: [
                    .default(Text(Strings.optimized.key)) { viewModel.sortOrder = .optimized },
                    .default(Text(Strings.creationDate.key)) { viewModel.sortOrder = .creationDate },
                    .default(Text(Strings.title.rawValue)) { viewModel.sortOrder = .title }
                    ])
            }

            SelectSomethingView()
        }
    }
}

struct ProjectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProjectsView(dataController: DataController.preview,
                     showClosedProjects: false)
    }
}
