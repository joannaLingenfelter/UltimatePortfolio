//
//  Project-CoreDataHelpers.swift
//  UltimatePortfolio
//
//  Created by Joanna Lingenfelter on 2/8/22.
//

import Foundation
import SwiftUI

extension Project {
    var projectTitle: String {
        title ?? Strings.newProject.keyStringValue.localized()
    }

    var projectDetail: String {
        detail ?? ""
    }

    var projectColor: String {
        color ?? "Light Blue"
    }

    var projectItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }

    var projectItemsDefaultSorted: [Item] {
        return projectItems.sorted { first, second in
            if first.completed == false {
                if second.completed {
                    return true
                }
            } else if first.completed {
                if second.completed == false {
                    return false
                }
            }

            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
               return false
            }

            return first.itemCreationDate > second.itemCreationDate
        }
    }

    var completionPercentage: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard !originalItems.isEmpty else { return 0.0 }

        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count)/Double(originalItems.count)
    }

    static var example: Project {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let project = Project(context: viewContext)
        project.title = "Example Project"
        project.detail = "This is an example Project"
        project.closed = true
        project.createdDate = Date()

        for itemCounter in 1...10 {
            let item = Item(context: viewContext)
            item.title = "Item \(itemCounter)"
            item.createdDate = Date()
            item.completed = Bool.random()
            item.project = project
            item.priority = Int16.random(in: 1...3)
        }

        return project
    }

    func projectItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .optimized:
            return projectItemsDefaultSorted
        case .title:
            return projectItems.sorted(by: \Item.itemTitle)
        case .creationDate:
            return projectItems.sorted(by: \Item.itemCreationDate)
        }
    }

    static let colors = ["Pink",
                         "Purple",
                         "Red",
                         "Orange",
                         "Gold",
                         "Green",
                         "Teal",
                         "Light Blue",
                         "Dark Blue",
                         "Midnight",
                         "Dark Gray",
                         "Gray"]

    var accessLabel: String {
        let convertedCompletionPercentage = String(describing: (completionPercentage * 100, specifier: "%g"))
        let itemCount = projectItems.count

        return String(format: Strings.summaryStatus.keyStringValue,
                      [projectTitle, itemCount, convertedCompletionPercentage]).localized()
    }
}
