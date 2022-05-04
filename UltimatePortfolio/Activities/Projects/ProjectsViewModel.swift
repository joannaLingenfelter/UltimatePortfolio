//
//  ProjectsViewModel.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 3/8/22.
//

import Foundation
import CoreData

extension ProjectsView {
    class ViewModel: NSObject,
                        ObservableObject,
                        NSFetchedResultsControllerDelegate {
        let dataController: DataController

        let showClosedProjects: Bool
        var sortOrder = Item.SortOrder.optimized

        private let projectsController: NSFetchedResultsController<Project>

        @Published var projects = [Project]()

        init(dataController: DataController, showClosedProjects: Bool) {
            self.dataController = dataController
            self.showClosedProjects = showClosedProjects

            let fetchRequest: NSFetchRequest<Project> = Project.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.createdDate,
                                                             ascending: false)]
            fetchRequest.predicate = NSPredicate(format: "closed = %d", showClosedProjects)
            projectsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: dataController.container.viewContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)
            super.init()
            projectsController.delegate = self

            do {
                try projectsController.performFetch()
                projects = projectsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch our items")
            }
        }

        func createProject() {
            let project = Project(context: dataController.container.viewContext)
            project.closed = false
            project.createdDate = Date()
            dataController.save()
        }

        func addItem(to project: Project) {
            let item = Item(context: dataController.container.viewContext)
            item.project = project
            item.createdDate = Date()
            dataController.save()
        }

        func deleteItems(from project: Project, at indexes: IndexSet) {
            let allItems = project.projectItems(using: sortOrder)

            for index in indexes {
                let item = allItems[index]
                dataController.delete(item)
            }

            dataController.save()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }
    }
}
