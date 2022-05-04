//
//  HomeViewModel.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 3/8/22.
//

import Foundation
import CoreData

extension HomeView {
    class ViewModel: NSObject,
                        ObservableObject,
                        NSFetchedResultsControllerDelegate {
        private let projectsController: NSFetchedResultsController<Project>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var projects = [Project]()
        @Published var items = [Item]()
        @Published var selectedItem: Item?

        var upNext: ArraySlice<Item> {
            return items.prefix(3)
        }

        var moreToExplore: ArraySlice<Item> {
            return items.dropFirst(3)
        }

        // Used for Preview in ItemListView
        static var previewHomeItems: ArraySlice<Item> {
            return Project.example.projectItems.prefix(3)
        }

        let dataController: DataController

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open projects
            let projectsRequest: NSFetchRequest<Project> = Project.fetchRequest()
            projectsRequest.predicate = NSPredicate(format: "closed = false")
            projectsRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Project.title, ascending: true)]

            projectsController = NSFetchedResultsController(fetchRequest: projectsRequest,
                                                            managedObjectContext: dataController.container.viewContext,
                                                            sectionNameKeyPath: nil,
                                                            cacheName: nil)

            // Construct a fetch request to show the 10 highest priority items.
            // This will include only incomplete items from open projects.
            let itemsRequest: NSFetchRequest<Item> = Item.fetchRequest()
            let completedPredicate = NSPredicate(format: "completed = false")
            let openPredicate = NSPredicate(format: "project.closed = false")

            itemsRequest.predicate = NSCompoundPredicate(type: .and,
                                                    subpredicates: [completedPredicate, openPredicate])
            itemsRequest.sortDescriptors = [
                NSSortDescriptor(keyPath: \Item.priority, ascending: false)
            ]
            itemsRequest.fetchLimit = 10

            itemsController = NSFetchedResultsController(fetchRequest: itemsRequest,
                                                         managedObjectContext: dataController.container.viewContext,
                                                         sectionNameKeyPath: nil,
                                                         cacheName: nil)

            super.init()
            projectsController.delegate = self
            itemsController.delegate = self

            do {
                try projectsController.performFetch()
                try itemsController.performFetch()

                projects = projectsController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch projects or items.")
            }
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newItems = controller.fetchedObjects as? [Item] {
                items = newItems
            } else if let newProjects = controller.fetchedObjects as? [Project] {
                projects = newProjects
            }
        }

        func selectItem(with identifier: String) {
            selectedItem = dataController.item(with: identifier)
        }
    }
}
