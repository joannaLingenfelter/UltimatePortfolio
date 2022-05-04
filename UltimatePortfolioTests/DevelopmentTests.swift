//
//  DevelopmentTests.swift
//  UltimatePortfolioTests
//
//  Created by Joanna Lingenfelter on 3/2/22.
//

import XCTest
import CoreData
@testable import UltimatePortfolio

class DevelopmentTests: BaseTestCase {
    func test_sample_data_is_created_as_expected() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 5 sample items.")
    }

    func test_deleteAll_clears_all_data() throws {
        try dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 0, "There should be 0 sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "There should be 0 sample items.")
    }

    func test_example_project_is_closed() {
        let project = Project.example
        XCTAssertTrue(project.closed, "The example project should be closed.")
    }

    func test_example_item_is_high_priority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3, "The example item should be high priority.")
    }
}
