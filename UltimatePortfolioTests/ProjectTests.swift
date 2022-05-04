//
//  ProjectTests.swift
//  UltimatePortfolioTests
//
//  Created by Joanna Lingenfelter on 3/1/22.
//

import XCTest
import CoreData
@testable import UltimatePortfolio

class ProjectTests: BaseTestCase {
    func test_creating_projects_and_items() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let project = Project(context: managedObjectContext)

            for _ in 0..<targetCount {
                let item = Item(context: managedObjectContext)
                item.project = project
            }
        }

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }

    func test_cascade_delete_functionality_so_items_in_a_project_are_deleted_with_the_project() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<Project>(entityName: "Project")
        let projects = try managedObjectContext.fetch(request)
        let preDeleteProjectCount = dataController.count(for: Project.fetchRequest())
        let preDeleteItemCount = dataController.count(for: Item.fetchRequest())

        guard let projectToDelete = projects.first,
                let deletedItemsCount = projectToDelete.items?.count else {
            XCTFail("There are no projects in the managed object context.")
            return
        }

        dataController.delete(projectToDelete)

        let afterDeleteProjectCount = dataController.count(for: Project.fetchRequest())
        let afterDeleteItemCount = dataController.count(for: Item.fetchRequest())

        XCTAssertEqual(afterDeleteProjectCount, preDeleteProjectCount - 1)
        XCTAssertEqual(afterDeleteItemCount, (preDeleteItemCount - deletedItemsCount))
    }
}
