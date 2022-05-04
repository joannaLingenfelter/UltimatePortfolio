//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by Joanna Lingenfelter on 3/3/22.
//

import XCTest
@testable import UltimatePortfolio

// swiftlint:disable line_length

class PerformanceTests: BaseTestCase {
    func test_award_calculation_performance() throws {
        try dataController.createSampleData()
        let awards = Award.allAwards

        measure {
            _ = awards.filter { dataController.hasEarned(award: $0) }
        }
    }

    func test_award_calculation_stress_test_performance() throws {
        // Create a significant amount of test data
        for _ in 1...100 {
            try dataController.createSampleData()
        }

        let awards = Array(repeating: Award.allAwards, count: 25).flatMap { $0 }
        XCTAssertEqual(awards.count, 500,
                       "This checks the number of awards is constant for the the event that the number of awards is changed in the future.")

        measure {
            _ = awards.filter { dataController.hasEarned(award: $0) }
        }
    }
}
